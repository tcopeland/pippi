module Pippi::Checks
  class SelectFollowedBySize < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      @mycheck = MethodSequenceChecker.new(self, Array, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, true)
    end

    class Documentation
      def description
        "Don't use select followed by size; use count instead"
      end

      def sample
        '[1,2,3].select {|x| x > 1 }.size'
      end

      def instead_use
        '[1,2,3].count {|x| x > 1 }'
      end
    end
  end
end
