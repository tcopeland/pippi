module Pippi::Checks
  class SelectFollowedBySize < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self, Array, MethodSequence.new("select", "size"))
      @mycheck = MethodSequenceChecker.new(check_descriptor)
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
