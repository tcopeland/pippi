module Pippi::Checks

  class SelectFollowedByEmpty < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self, Array)
      check_descriptor.method_sequence = MethodSequence.new("select", "empty?")
      @mycheck = MethodSequenceChecker.new(check_descriptor)
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
