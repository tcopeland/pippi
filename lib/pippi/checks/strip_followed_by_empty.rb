module Pippi::Checks

  # This is a Rails-only check; how to call it out as such?
  # Putting it in a "rails" checkset for now
  class StripFollowedByEmpty < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self)
      check_descriptor.clazz_to_decorate = String
      check_descriptor.method1 = "strip"
      check_descriptor.method2 = "empty?"
      check_descriptor.first_method_arity_type = MethodSequenceChecker::ARITY_TYPE_NONE
      check_descriptor.second_method_arity_type = MethodSequenceChecker::ARITY_TYPE_NONE
      @mycheck = MethodSequenceChecker.new(check_descriptor)
    end

    class Documentation
      def description
        "Don't use String#strip followed by empty?; use String#blank? instead"
      end
      def sample
        "'   '.strip.empty?"
      end
      def instead_use
        "'   '.blank?"
      end
    end

  end

end
