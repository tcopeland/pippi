require 'rake/testtask'
require 'rubygems'
require 'bundler/setup'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/unit/**_test.rb"
end

task :default => [:test]