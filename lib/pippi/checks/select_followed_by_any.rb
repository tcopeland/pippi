module Pippi::Checks

  class SelectFollowedByAny < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self, Array, MethodSequence.new("select", "any?"))
      @mycheck = MethodSequenceChecker.new(check_descriptor)
    end

    class Documentation
      def description
        "Don't use select followed by any?; use any? with a block instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.any?"
      end
      def instead_use
        "[1,2,3].any? {|x| x > 1 }"
      end
    end

  end

end
