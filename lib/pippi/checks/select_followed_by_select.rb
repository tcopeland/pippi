module Pippi::Checks

  class SelectFollowedBySelect < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self)
      check_descriptor.clazz_to_decorate = Array
      check_descriptor.method1 = "select"
      check_descriptor.method2 = "select"
      check_descriptor.first_method_arity_type = MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG
      check_descriptor.second_method_arity_type = MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG
      check_descriptor.should_check_subsequent_calls = false
      @mycheck = MethodSequenceChecker.new(check_descriptor)
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
