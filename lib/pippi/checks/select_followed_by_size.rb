module Pippi::Checks
  class SelectFollowedBySize < Check

    def initialize(ctx)
      super
      @result_of_select_invocation = nil
    end

    def c_call_event(tp)
      if @result_of_select_invocation.object_id == tp.self.object_id
        @result_of_select_invocation = nil
      end
    end

    def line_event(tp)
      if @result_of_select_invocation && tp.path == @result_of_select_invocation.the_original_tp_info[1] && tp.lineno != @result_of_select_invocation.the_original_tp_info[0]
        ctx.debug_logger.warn "Clearing since line_event #{tp.lineno}"
        @result_of_select_invocation = nil
      end
    end

    def size_call_event
      return unless @result_of_select_invocation
      ctx.report.add(Pippi::Problem.new(:line_number => @result_of_select_invocation.the_original_tp_info[0], :file_path => @result_of_select_invocation.the_original_tp_info[1], :check_class => self.class))
      @result_of_select_invocation = nil
    end

    def c_return_event(tp)
      if tp.defined_class == Array && tp.method_id == :select
        ctx.debug_logger.warn "Alerting on #select on #{tp.return_value.object_id} at #{tp.path} line #{tp.lineno}"
        @result_of_select_invocation = tp.return_value
        the_check = self
        @result_of_select_invocation.instance_eval {
@the_check = the_check
@the_original_tp_info = [tp.lineno, tp.path]
def the_original_tp_info ; @the_original_tp_info ; end
alias :size_without_check :size
def size_with_check
  @the_check.size_call_event if @the_check
  size_without_check
end
alias :size :size_with_check
}
      end
    end

    class Documentation

      def description
        "Don't use #select followed by #size; instead use the block version of #count"
      end

      def sample
        "[1,2,3].select {|x| x > 1 }.size"
      end

      def instead_use
        "[1,2,3].count {|x| x > 1 }"
      end

    end

  end
end
