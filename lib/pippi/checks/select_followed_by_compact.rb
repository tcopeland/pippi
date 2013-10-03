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
        ctx.report.add(Pippi::Problem.new(:line_number => tp.lineno, :file_path => tp.path, :check_class => self.class))
      end
    end

    class Documentation

      def description
        "Don't use #select followed by #compact; instead include a non-nil check in the select block"
      end

      def sample_code
        "[1,2,nil].select {|x| in_list(x) }.compact"
      end

      def instead_use
        "[1,2,nil].select {|x| x.present? && x.in_list? }"
      end
    end

  end
end
