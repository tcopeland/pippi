require 'rake/testtask'
require 'rubygems'
require 'bundler/setup'
require 'pippi/tasks'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/unit/**_test.rb'
end

task default: [:test]
