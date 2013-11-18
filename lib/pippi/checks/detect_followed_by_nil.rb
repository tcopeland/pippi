module Pippi::Checks

  class DetectFollowedByNil < Check

    def initialize(ctx)
      super
      @result_of_detect_invocation = nil
      @return_on_line = nil
    end

    def c_call_event(tp)
      if @result_of_detect_invocation.object_id == tp.self.object_id && @return_on_line == tp.lineno
        # I think tp.method_id == :present? is unnecessary because Rails will check for nil in
        # the extension, but seems more complete to explicitly check
        if tp.method_id == :nil? || tp.method_id == :present?
          ctx.report.add(Pippi::Problem.new(:line_number => tp.lineno, :file_path => tp.path, :check_class => self.class))
        else
          @result_of_detect_invocation = nil
        end
      end
    end

    def c_return_event(tp)
      if tp.defined_class == Enumerable && tp.method_id == :detect
        @result_of_detect_invocation = tp.return_value
        @return_on_line = tp.lineno
      end
    end

    class Documentation

      def description
        "Don't use #detect followed by #nil?; instead use #any?"
      end

      def sample_code
        "[1,2,3].detect {|x| x > 2}.nil?"
      end

      def instead_use
        "[1,2,3].any? {|x| x > 2}"
      end

    end

  end
end
