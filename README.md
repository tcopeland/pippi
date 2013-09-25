Pippi is a Ruby runtime code analysis tool

Examples of problems to detect:

# unnecessary assignment since String#strip! mutates receiver 
# wrong
x = x.strip!
# right
x.strip!

# use Enumerable#detect instead
# wrong
[1,2,3].select {|x| x > 1 }.first
# right
[1,2,3].detect {|x| x > 1 }

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

# Unnecessary compact
# wrong
[1,2,nil].select {|x| in_list(x) }.compact
# right
[1,2,nil].select {|x| x.present? && x.in_list? }
# something with replacing x.map.compact with x.select.map


Developing

Switch to Ruby 2.0 with:

chruby ruby-2.0.0-p247

Setup 

To install Ruby 2.0, first had to install openssl:

cd ~/src/
curl -O http://www.openssl.org/source/openssl-1.0.1e.tar.gz
tar -zxf openssl-1.0.1e.tar.gz 
cd openssl-1.0.1e
./Configure darwin64-x86_64-cc --prefix=/usr/local/openssl-1.0.1e
make
sudo make install

Then install Ruby with:

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

Some good docs there:

http://www.ruby-doc.org/core-2.0.0/TracePoint.html

Why "pippi"?  Because Pippi Longstocking was a <A href="http://www.laredoisd.org/cdbooks/NOVELS/Pippi%20Longstocking/CH02.txt">Thing-Finder</a>, and pippi finds things.