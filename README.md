# Pippi

Pippi is a utility for finding suboptimal Ruby class API usage.

[Here's a project overview](http://thomasleecopeland.com/2014/10/22/finding-suboptimal-api-usage.html).

## Checksets

Pippi has the concept of "checksets" which are, well, sets of checks.  The current checksets are listed below.

Maybe we should have a dedicated "test" checkset?  Let me know what you think at https://twitter.com/tcopeland, thanks!

### Basic

* SelectFollowedByFirst
* SelectFollowedBySize
* ReverseFollowedByEach

### Buggy

* AssertWithNil
* MapFollowedByFlatten

## Checks

### AssertWithNil

Don't use assert_equal with nil as a first argument; use assert_nil instead

For example, rather than doing this:

```ruby
x = nil ; assert_equal(nil, x)
```

Instead, consider doing this:

```ruby
x = nil ; assert_nil(x)
```

### MapFollowedByFlatten

Don't use map followed by flatten; use flat_map instead

For example, rather than doing this:

```ruby
[1,2,3].map {|x| [x,x+1] }.flatten
```

Instead, consider doing this:

```ruby
[1,2,3].flat_map {|x| [x, x+1]}
```

### ReverseFollowedByEach

Don't use each followed by reverse; use reverse_each instead

For example, rather than doing this:

```ruby
[1,2,3].reverse.each {|x| x+1 }
```

Instead, consider doing this:

```ruby
[1,2,3].reverse_each {|x| x+1 }
```

### SelectFollowedByFirst

Don't use select followed by first; use detect instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.first
```

Instead, consider doing this:

```ruby
[1,2,3].detect {|x| x > 1 }
```

### SelectFollowedBySize

Don't use select followed by size; use count instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.size
```

Instead, consider doing this:

```ruby
[1,2,3].count {|x| x > 1 }
```

## Usage

### Inside Rails tests

See [demo](https://github.com/tcopeland/pippi_demo#pippi-demo)

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

## Ideas for other problems to detect:

```ruby
# Don't use select followed by compact, use select with the nil inside the block

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
* Make writing rules nicer, without some much dorking around with methods.  "select followed by first" could be specified with something like "Array#select => #first" and the rest left up to the framework.

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
* Thanks to Evan Phoenix for the idea of watching method invocations at runtime using metaprogramming rather than using `Tracepoint`.
* Thanks to Michael Bernstein (of Code Climate fame) for an inspirational discussion of code anaysis in general.
