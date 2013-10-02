module Pippi::Checks
  class SelectFollowedByCompact < Check

    def initialize(ctx)
      super
      @result_of_select_invocation = nil
    end

    def c_return_event(tp)
      if tp.defined_class == Array && tp.method_id == :select
        @result_of_select_invocation = tp.return_value
      end
    end

    def c_call_event(tp)
      if tp.defined_class == Array && tp.method_id == :compact && @result_of_select_invocation.object_id == tp.self.object_id
        ctx[:report].add(Pippi::Problem.new(:line_number => tp.lineno, :file_path => tp.path, :rule_class => self.class))
      end
    end

  end
end
