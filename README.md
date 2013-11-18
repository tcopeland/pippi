Pippi is a Ruby runtime code analysis tool

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
bundle exec pippi tmp/tmpfile.rb SelectFollowedByCompact Foo.new.bar out.txt
# Or to run all the basic Pippi checks on your code and exercise it with MyClass.new.exercise_some_code:
bundle exec ruby -rpippi/auto_runner -e "MyClass.new.exercise_some_code"
```

This will get easier once I release the gem, which I'll do once I feel like there's a critical mass of rules.

## Ideas for other problems to detect:

```ruby
# Use #any? rather than #detect followed by #present since it makes it more clear that you're checking for the presence of something without needing the thing itself
# wrong
[1,2,3].detect {|x| x > 2}.present?
# right
[1,2,3].any? {|x| x > 2 }

# Similar to one above except it's even more of an optimization since you don't have to iterate over the entire list
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

## Developing

Switch to Ruby 2.0 with:

```bash
chruby ruby-2.0.0-p247
```

To see trace point event output for a file `tmp/baz.rb`:

```bash
rm -f pippi_debug.log ; PIPPI_DEBUG=1 bundle exec pippi tmp/baz.rb DebugCheck Foo.new.bar tmp/out.txt ; cat pippi_debug.log
```

When trying to find issues in a project:

```bash
# in pippi directory
rm -f pippi-0.0.1.gem && gem build pippi.gemspec && mv pippi-0.0.1.gem ~/github.com/aasm/vendor/cache/

# in project directory (e.g., aasm)
chruby ruby-2.0.0-p247
rm -rf pippi_debug.log pippi.log .bundle/gems/pippi-0.0.1/ .bundle/cache/pippi-0.0.1.gem .bundle/specifications/pippi-0.0.1.gemspec && bundle update pippi --local && PIPPI_DEBUG=1 be ruby -rpippi/auto_runner -e "puts 'hi'" && grep -C 5 BOOM pippi_debug.log
# or to run a spec with pippi watching:
rm -rf pippi_debug.log pippi.log .bundle/gems/pippi-0.0.1/ .bundle/cache/pippi-0.0.1.gem .bundle/specifications/pippi-0.0.1.gemspec && bundle update pippi --local && PIPPI_DEBUG=1 be ruby -rpippi/auto_runner -Ispec spec/unit/transition_spec.rb && grep -C 5 BOOM pippi_debug.log
```

### Setup

To install Ruby 2.0 on OSX 10.7.5, first had to install openssl:

```bash
cd ~/src/
curl -O http://www.openssl.org/source/openssl-1.0.1e.tar.gz
tar -zxf openssl-1.0.1e.tar.gz 
cd openssl-1.0.1e
./Configure darwin64-x86_64-cc --prefix=/usr/local/openssl-1.0.1e
make
sudo make install
```

Then install Ruby with:

```bash
# It will output the warning below, but then work anyway:
# configure: WARNING: unrecognized options: --with-openssl-dir
./configure --prefix=/opt/rubies/ruby-2.0.0-p247 --with-openssl-dir=/usr/local/openssl-1.0.1e/
make
cd ext/openssl
# edit openssl_missing.h and add these lines around line 28-29
#define HAVE_HMAC_CTX_COPY 1
#define HAVE_EVP_CIPHER_CTX_COPY 1
# or install it and then do chruby ruby-2.0.0-p247, otherwise you will get have_func errors
../../bin/ruby extconf.rb --with-openssl-dir=/usr/local/openssl-1.0.1e/bin/
```

Some good docs there:

http://www.ruby-doc.org/core-2.0.0/TracePoint.html

## Why "pippi"?

Because Pippi Longstocking was a <A href="http://www.laredoisd.org/cdbooks/NOVELS/Pippi%20Longstocking/CH02.txt">Thing-Finder</a>, and pippi finds things.
