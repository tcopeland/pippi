module Pippi::Checks

  class SelectFollowedBySelect < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      @mycheck = MethodSequenceChecker.new(self, Array, "select", "select", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, false)
    end

    class Documentation
      def description
        "Don't use consecutive select blocks; use a single select instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.select {|x| x > 2 }"
      end
      def instead_use
        "[1,2,3].select {|x| x > 2 }"
      end
    end

  end

end
