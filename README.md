Pippi is a Ruby runtime code analysis tool

Using the Aaron Quint "Ruby Performance Character Profiles" (https://www.youtube.com/watch?v=cOaVIeX6qGg&t=8m50s) system:

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
gem 'pippi', :path => "../pippi"
# Run 'bundle', see some output
# To run a particular check:
bundle exec pippi tmp/tmpfile.rb MapFollowedByFlatten Foo.new.bar out.txt
# Or to run all the basic Pippi checks on your code and exercise it with MyClass.new.exercise_some_code:
bundle exec ruby -rpippi/auto_runner -e "MyClass.new.exercise_some_code"
```

This will get easier once I release the gem, which I'll do once I feel like there's a critical mass of rules.

## Ideas for other problems to detect:

```ruby
# Use assert_nil rather than assert_equals
# wrong
assert_equals(nil, foo)
# right
assert_nil foo

# Similar to 'detect followed by nil?' except it's even more of an optimization since you don't have to iterate over the entire list
# wrong
[1,2,3].select {|x| x > 2}.size > 0
# right
[1,2,3].any? {|x| x > 2}

# wrong
[1,2,3].select {|x| x > 2 }.size == 1
# right
[1,2,3].one? {|x| x > 2 }

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

# something with replacing x.map.compact with x.select.map
````

## TODO

* Generate documentation from the docs embedded in the checks and publish that somewhere
* Clean up this context/report/loader/blah mess
* Maybe make documentation generate DSL-style

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

