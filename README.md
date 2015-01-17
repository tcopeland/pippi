# Pippi

[![Build Status](http://img.shields.io/travis/tcopeland/pippi.svg)](http://travis-ci.org/tcopeland/pippi)

Pippi is a utility for finding suboptimal Ruby class API usage.

Consider this little array:

```ruby
[1, 2, 3]
```

Now suppose we want to find the first element in that array that's greater than one. We can use Array#select, which returns another Array, and then use Array#first:

```ruby
[1, 2, 3].select { |x| x > 1 }.first
```

Of course that's terribly inefficient. Since we only need one element we don't need to select all elements that match the predicate. We should use Array#detect instead:

```ruby
[1, 2, 3].detect { |x| x > 1 }
```

A change like this is a small optimization, but they can add up.  More importantly, they communicate the intent of the programmer; the use of Array#detect makes it clear that we're just looking for the first item to match the predicate.

This sort of thing can be be found during a code review, or maybe when you're just poking around the code. But why not have a tool find it instead? Thus, pippi. Pippi observes code while it's running - by hooking into your test suite execution - and reports misuse of class-level APIs.

There are many nifty Ruby static analysis tools - flay, reek, flog, etc. This is not like those. It doesn't parse source code; it doesn't examine an abstract syntax tree or even sequences of MRI instructions. So it cannot find the types of issues that those tools can find. Instead, it's focused on runtime analysis; that is, method calls and method call sequences.

Here's an important caveat: pippi is not, and more importantly cannot, be free of false positives. That's because of the halting problem. Pippi finds suboptimal API usage based on data flows as driven by a project's test suite. There may be alternate data flows where this API usage is correct. For example, in the code below, if rand < 0.5 is true, then the Array will be mutated and the program cannot correctly be simplified by replacing "select followed by first" with "detect":

```ruby
x = [1, 2, 3].select { |y| y > 1 }
x.reject! { |y| y > 2 } if rand < 0.5
x.first
```

There are various techniques that eliminate many of these false positives. For example, after flagging an issue, pippi watches subsequent method invocations and if those indicate the initial problem report was in error it'll remove the problem from the report.

Pippi is entirely dependent on the test suite to execute code in order to find problems. If a project's test code coverage is small, pippi probably won't find much.

Here's how pippi stacks up using the [Aaron Quint](https://twitter.com/aq) [Ruby Performance Character Profiles](https://www.youtube.com/watch?v=cOaVIeX6qGg&t=8m50s) system:

* Specificity - very specific, finds actual detailed usages of bad code
* Impact - very impactful, slows things down lots
* Difficulty of Operator Use - easy to install, just a new gemfile entry
* Readability - results are easy to read
* Realtimedness - finds stuff right away
* Special Abilities - ?

Finally, why "pippi"? Because Pippi Longstocking was a <a href="http://www.laredoisd.org/cdbooks/NOVELS/Pippi%20Longstocking/CH02.txt">Thing-Finder</a>, and pippi finds things.

## Usage

### Rails with test-unit

* Add `gem 'pippi'` to the `test` group in your project's `Gemfile`
* Add this to `test_helper.rb` just before the `require 'rails/test_help'` line

```ruby
if ENV['USE_PIPPI'].present?
  Pippi::AutoRunner.new(:checkset => ENV['PIPPI_CHECKSET'] || "basic")
  # you can also pass in an IO:
  # Pippi::AutoRunner.new(:checkset => "basic", :io => $stdout)
end
```
* Run it:

```text
USE_PIPPI=true bundle exec rake test:units && cat log/pippi.log
```

* You can also select a different checkset:

```text
USE_PIPPI=true PIPPI_CHECKSET=training bundle exec rake test:units && cat log/pippi.log
```


Here's a [demo Rails application](https://github.com/tcopeland/pippi_demo#pippi-demo).

### Rails with rspec

* Add `gem 'pippi'` to the `test` group in your project's `Gemfile`
* Add this to `spec/spec_helper.rb`, just below the `require 'rspec/rails'` line (if there is one):

```ruby
if ENV['USE_PIPPI'].present?
  require 'pippi'
  Pippi::AutoRunner.new(:checkset => ENV['PIPPI_CHECKSET'] || "basic")
end
```

* Run it:

```text
USE_PIPPI=true bundle exec rake spec && cat log/pippi.log
```

### As part of a continuous integration job

[Dan Kohn](https://github.com/dankohn) suggests you could use something like:

```bash
if grep -v gem < log/pippi.log; then echo "$(wc -l < log/pippi.log) Pippi flaws found" && false; else echo 'No pippi flaws found'; fi
```

### From the command line:

Assuming you're using bundler:

```bash
# Add this to your project's Gemfile:
gem 'pippi'
# Run 'bundle', see some output
# To run a particular check:
bundle exec pippi tmp/tmpfile.rb MapFollowedByFlatten Foo.new.bar out.txt
# Or to run all the basic Pippi checks on your code and exercise it with MyClass.new.exercise_some_code:
bundle exec ruby -rpippi/auto_runner -e "MyClass.new.exercise_some_code"
```


## Checksets

Pippi has the concept of "checksets" which are, well, sets of checks.  The current checksets are listed below.

### basic

#### ReverseFollowedByEach

Don't use each followed by reverse; use reverse_each instead

For example, rather than doing this:

```ruby
[1, 2, 3].reverse.each { |x| x + 1 }
```

Instead, consider doing this:

```ruby
[1, 2, 3].reverse_each { |x| x + 1 }
```

#### SelectFollowedByAny

Don't use select followed by any?; use any? with a block instead

For example, rather than doing this:

```ruby
[1, 2, 3].select { |x| x > 1 }.any?
```

Instead, consider doing this:

```ruby
[1, 2, 3].any? { |x| x > 1 }
```

#### SelectFollowedByEmpty

Don't use select followed by empty?; use none? instead

For example, rather than doing this:

```ruby
[1, 2, 3].select { |x| x > 1 }.empty?
```

Instead, consider doing this:

```ruby
[1, 2, 3].none? { |x| x > 1 }
```

#### SelectFollowedByFirst

Don't use select followed by first; use detect instead

For example, rather than doing this:

```ruby
[1, 2, 3].select { |x| x > 1 }.first
```

Instead, consider doing this:

```ruby
[1, 2, 3].detect { |x| x > 1 }
```

#### SelectFollowedByNone

Don't use select followed by none?; use none? with a block instead

For example, rather than doing this:

```ruby
[1, 2, 3].select { |x| x > 1 }.none?
```

Instead, consider doing this:

```ruby
[1, 2, 3].none? { |x| x > 1 }
```

#### SelectFollowedBySelect

Don't use consecutive select blocks; use a single select instead

For example, rather than doing this:

```ruby
[1, 2, 3].select { |x| x > 1 }.select { |x| x > 2 }
```

Instead, consider doing this:

```ruby
[1, 2, 3].select { |x| x > 2 }
```

#### SelectFollowedBySize

Don't use select followed by size; use count instead

For example, rather than doing this:

```ruby
[1 ,2, 3].select { |x| x > 1 }.size
```

Instead, consider doing this:

```ruby
[1, 2, 3].count { |x| x > 1 }
```
### buggy

#### AssertWithNil

Don't use assert_equal with nil as a first argument; use assert_nil instead

For example, rather than doing this:

```ruby
x = nil ; assert_equal(nil, x)
```

Instead, consider doing this:

```ruby
x = nil ; assert_nil(x)
```

#### MapFollowedByFlatten

Don't use map followed by flatten(1); use flat_map instead

For example, rather than doing this:

```ruby
[1, 2, 3].map { |x| [x, x + 1] }.flatten(1)
```

Instead, consider doing this:

```ruby
[1, 2, 3].flat_map { |x| [x, x + 1] }
```

## Ideas for other problems to detect:

```ruby
# unnecessary assignment since String#strip! mutates receiver
# wrong
x = x.strip!
# right
x.strip!

# Use Pathname
# wrong
File.read(File.join(Rails.root, "config", "database.yml")
# right
Rails.root.join("config", "database.yml").read

# Use Kernel#tap
# wrong
x = [1,2]
x << 3
return x
# right
[1,2].tap {|y| y << 3 }


# Rails checks

# No need to call to_i on ActiveRecord::Base methods passed to route generators
# wrong
product_path(@product.to_i)
# right
product_path(@product)

# something with replacing x.map.compact with x.select.map
````

## Here are some things that Pippi is not well suited for

Use self.new vs MyClass.new. This is not a good fit for Pippi because it
involves a receiver usage that can be detected with static analysis.

**wrong**:

```
class Foo
  def self.bar
    Foo.new
  end
end
```

**right**:

```
class Foo
  def self.bar
    self.new
  end
end
```

## TODO

* Clean up this initial hacked out metaprogramming
* Do more checks
* Finish refactoring duplicated code into MethodSequenceChecker
* Use MethodSequenceFinder to do something with String

## Developing

To see teacher output for a file `tmp/baz.rb`:

```bash
rm -f pippi_debug.log ; PIPPI_DEBUG=1 bundle exec pippi tmp/baz.rb DebugCheck Foo.new.bar tmp/out.txt ; cat pippi_debug.log
```

When trying to find issues in a project:

```bash
# in project directory (e.g., aasm)
rm -rf pippi_debug.log pippi.log .bundle/gems/pippi-0.0.1/ .bundle/cache/pippi-0.0.1.gem .bundle/specifications/pippi-0.0.1.gemspec && bundle update pippi --local && PIPPI_DEBUG=1 bundle exec ruby -rpippi/auto_runner -e "puts 'hi'" && grep -C 5 BOOM pippi_debug.log
# or to run some specs with pippi watching:
rm -rf pippi_debug.log pippi.log .bundle/gems/pippi-0.0.1/ .bundle/cache/pippi-0.0.1.gem .bundle/specifications/pippi-0.0.1.gemspec && bundle update pippi --local && PIPPI_DEBUG=1 bundle exec ruby -rpippi/auto_runner -Ispec spec/unit/*.rb
```

## How to do a release

* Bump version number
* Move anything from 'training' to 'buggy' or elsewhere
* Tie off Changelog notes
* Regenerate docs with `pippi:generate_docs`, copy and paste that into README
* Commit, push
* Tag the release (e.g., `git tag -a v0.0.8 -m 'v0.0.8' && git push origin v0.0.8`)
* `bundle exec gem build pippi.gemspec`
* `gem push pippi-x.gem`
* Update pippi_demo

## Credits

* Christopher Schramm([@cschramm](https://github.com/cschramm)) bugfixes in fault proc clearing
* Enrique Delgado: Documentation fixes
* [Evan Phoenix](https://twitter.com/evanphx)([@evanphx](https://github.com/evanphx)) for the idea of watching method invocations at runtime using metaprogramming rather than using `Tracepoint`.
* Hubert Dąbrowski: Ruby 2.0.0 fixes
* [Igor Kapkov](https://twitter.com/igasgeek)([@igas](https://github.com/igas)) documentation fixes
* [Josh Bodah](https://github.com/jbodah): Better logging support
* [LivingSocial](https://www.livingsocial.com/) for letting me develop and open source this utility.
* [Michael Bernstein](https://twitter.com/mrb_bk)([@mrb](https://github.com/mrb)) (of [CodeClimate](https://codeclimate.com/) fame) for an inspirational discussion of code anaysis in general.
* [Olle Jonsson](https://twitter.com/olleolleolle)([@olleolleolle](https://github.com/olleolleolle)) rubocop fixes
