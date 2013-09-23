
require 'rubygems'
require 'bundler'

Bundler.require

def foo
  bar = [1,2,3]
  baz = bar.select {|x| x > 1}
  baz.first
end

def checkit(tp)
  return unless tp.defined_class == Array && tp.method_id == :select
  # puts tp.methods.sort - Object.methods.sort
end

TracePoint.trace(:c_call) do |tp|
  checkit(tp)
end

foo

