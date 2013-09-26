module Pippi::Checks
  class SelectFollowedByFirst
    # TODO inherit from base class
    attr_accessor :ctx
    def initialize(ctx)
      # TODO make a PippiContext
      @ctx = ctx
      @result_of_select_invocation = nil
    end
    # TODO framework should register tracepoints and invoke event type methods on checks
    def register_tracepoint
      TracePoint.trace(:c_call, :c_return) do |tp|
        next unless tp.defined_class == Array && (tp.method_id == :select || tp.method_id == :first)

        # grab the result of the select call
        if tp.method_id == :select && tp.event == :c_return # TODO also check for msg receiver of Array
          @result_of_select_invocation = tp.return_value
        end

        # was this the object we called select on?  if so, are we calling #first?
        # if any methods were invoked in the meantime, don't check this
        if tp.event == :c_call && @result_of_select_invocation.object_id == tp.self.object_id && tp.method_id == :first
          # TODO make a Pippi::Report
          (ctx[:report] ||= []) << "got one"
        end
      end
    end
  end
end
