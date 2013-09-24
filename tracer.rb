require 'rubygems'
require 'bundler'

Bundler.require

class SelectFollowedByFirstFinder
  def initialize
    @result_of_select_invocation = nil
  end  
  def register_tracepoint
    TracePoint.trace(:c_call, :c_return) do |tp|
      next unless tp.defined_class == Array && (tp.method_id == :select || tp.method_id == :first)
      
      # grab the result of the select call 
      if tp.method_id == :select && tp.event == :c_return # TODO also check for msg receiver of Enumerable
        @result_of_select_invocation = tp.return_value
      end
    
      # was this the object we called select on?  if so, are we calling #first?
      # if any methods were invoked in the meantime, don't check this
      if tp.event == :c_call && @result_of_select_invocation.object_id == tp.self.object_id && tp.method_id == :first
        puts "GOT ONE"
      end
    end
  end
end

def foo
  x = [1,2,3].select {|x| x > 1}
  [1,2].first
end

def foo2
  [1,2,3].select {|x| x > 1}.first
end

f = SelectFollowedByFirstFinder.new
f.register_tracepoint
puts "should not find one"
foo
puts "should find one"
foo2
puts "should not find one"
foo

######
# @result_of_select_invocation = nil
# 
# TracePoint.trace(:c_call, :c_return) do |tp|
#   next unless tp.defined_class == Array && (tp.method_id == :select || tp.method_id == :first)
#   
#   # grab the result of the select call 
#   if tp.method_id == :select && tp.event == :c_return # TODO also check for msg receiver of Enumerable
#     @result_of_select_invocation = tp.return_value
#   end
# 
#   # was this the object we called select on?  if so, are we calling #first?
#   # if any methods were invoked in the meantime, don't check this
#   if tp.event == :c_call && @result_of_select_invocation.object_id == tp.self.object_id && tp.method_id == :first
#     puts "GOT ONE"
#   end
#     
#   # puts "#{tp.event} - method_id is #{tp.method_id}"
#   # puts "tp.self.object_id is #{tp.self.object_id}"
# end
######

# 
# foo2

# TracePoint.trace(:c_return) do |tp|
#   next unless tp.defined_class == Array && (tp.method_id == :select || tp.method_id == :first)
#   puts "RETURN"
#   puts "tp.self.object_id is #{tp.self.object_id}"
#   puts "return_value is #{tp.return_value}"
#   puts "return_value object id is #{tp.return_value.object_id}"
# end

# TracePoint.trace do |tp|
#   next if tp.method_id == :puts || tp.method_id == :write
#   warn "line %4s %-8s %-11p" % [tp.lineno, tp.event, tp.method_id] 
# end
# 
