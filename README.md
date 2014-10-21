Pippi is a utility for locating suboptimal Ruby class API usage.

For example, consider an array:

```ruby
[1,2,3]
```

You may wish to find the first item greater than 1 in this array, so:

```ruby
[1,2,3].select {|x| x > 1 }.first
```

But this can be more clearly written using `Enumerable#detect`:

```ruby
[1,2,3].detect {|x| x > 1 }
```

When you run your tests, Pippi will observe the method call sequences, flag the "select followed by first" sequence, and recommend a change.

Warning!  Pippi finds suboptimal API usage based on data flows as driven by a project's test suite.  There may be other data flows where this API usage is correct.  For example, in the code below, if `rand < 0.5` is true, then the Array will be mutated and the program cannot correctly be simplified by replacing "select followed by first" with "detect":

```ruby
x = [1,2,3].select {|y| y > 1 }
x.reject! {|y| y > 2} if rand < 0.5
x.first
```

This is the halting problem; I don't see a way to avoid this.

However, Pippi does use various techniques to attempt to avoid false positives.  For example, after flagging an issue, it watches subsequent method invocations and if those indicate the initial problem report was in error it'll remove the problem from the report.

Using <a href="https://www.youtube.com/watch?v=cOaVIeX6qGg&t=8m50s">the Aaron Quint "Ruby Performance Character Profiles"</a> system:

* Specificity - very specific, finds actual detailed usages of bad code
* Impact - very impactful, slows things down lots
* Difficulty of Operator Use - easy to install, just a new gemfile entry
* Readability - results are easy to read
* Realtimedness - finds stuff right away
* Special Abilities - ??

Why "pippi"?  Because Pippi Longstocking was a <a href="http://www.laredoisd.org/cdbooks/NOVELS/Pippi%20Longstocking/CH02.txt">Thing-Finder</a>, and pippi finds things.

## Usage

### Inside Rails tests

See https://github.com/tcopeland/pippi_demo#pippi-demo

### From the command line:

Assuming you're using bundler:

```bash
# clone this repo as a sibling directory to your project
git clone https://github.com/tcopeland/pippi.git
# Add this to your project's Gemfile:
gem 'pippi'
# Run 'bundle', see some output
# To run a particular check:
bundle exec pippi tmp/tmpfile.rb MapFollowedByFlatten Foo.new.bar out.txt
# Or to run all the basic Pippi checks on your code and exercise it with MyClass.new.exercise_some_code:
bundle exec ruby -rpippi/auto_runner -e "MyClass.new.exercise_some_code"
```

## Ideas for other problems to detect:

```ruby
# Don't use select followed by compact, use select with the nil inside the block
# Use assert_nil rather than assert_equals
# wrong
assert_equals(nil, foo)
# right
assert_nil foo

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

# Here are some things that Pippi is not well suited for
# Use self.new vs MyClass.new.  This is not a good fit for Pippi because it involves a receiver usage that can be detected with static analysis.
# wrong
class Foo
  def self.bar
    Foo.new
  end
end
# right
class Foo
  def self.bar
    self.new
  end
end


## TODO

* Generate documentation from the docs embedded in the checks and publish that somewhere
* Clean up this initial hacked out metaprogramming
* Do more checks

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

## Credits

* Thanks to <a href="https://www.livingsocial.com/">LivingSocial</a> for letting me develop and open source this utility.
* Thanks to Evan Phoenix for the idea of watching method invocations at runtime using metaprogramming rather than using `Tracepoints`.
* Thanks to Michael Bernstein (of Code Climate fame) for an inspirational discussion of code anaysis in general.
