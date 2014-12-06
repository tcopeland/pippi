module Pippi::Checks

  class SelectFollowedByEmpty < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      @mycheck = MethodSequenceChecker.new(self, Array, "select", "empty?", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, true)
    end

    class Documentation
      def description
        "Don't use select followed by empty?; use none? instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.empty?"
      end
      def instead_use
        "[1,2,3].none? {|x| x > 1 }"
      end
    end

  end

end
