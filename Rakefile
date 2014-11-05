require 'rake/testtask'
require 'rubygems'
require 'bundler/setup'
require 'pippi/tasks'

Rake::TestTask.new do |t|
  t.name = "test:units"
  t.libs << 'test'
  t.pattern = 'test/unit/**_test.rb'
end

Rake::TestTask.new do |t|
  t.name = "test:integrations"
  t.libs << 'test'
  t.pattern = 'test/integration/**_test.rb'
end

task default: [:"test:units", :"test:integrations"]
