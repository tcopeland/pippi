module Pippi::Checks

  class SelectFollowedByNone < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self)
      check_descriptor.clazz_to_decorate = Array
      check_descriptor.method_sequence = MethodSequence.new("select", "none?")
      @mycheck = MethodSequenceChecker.new(check_descriptor)
    end

    class Documentation
      def description
        "Don't use select followed by none?; use none? with a block instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.none?"
      end
      def instead_use
        "[1,2,3].none? {|x| x > 1 }"
      end
    end

  end

end
