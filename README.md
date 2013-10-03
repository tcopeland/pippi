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
# then run Pippi on one of your files, in this case, some_file_to_run.rb, and exercise it with Foo.new.bar:
bundle exec pippi some_file_to_run.rb SelectFollowedByCompact Foo.new.bar out.txt
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

# something with replacing x.map.compact with x.select.map
````

## TODO

* Generate documentation from the docs embedded in the checks and publish that somewhere
* Clean up this context/report/loader/blah mess
* Implement more checks
* Allow running with just an additional require, like `bundle exec ruby -rpippi/autorunner my_program`

## Developing

Switch to Ruby 2.0 with:

```bash
chruby ruby-2.0.0-p247
```

To run it:

```bash
bundle exec bin/pippi tmp/tmpfile.rb SelectFollowedByFirst Foo.new.bar tmp/out.txt
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