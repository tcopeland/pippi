module Pippi::Checks

  # This is a Rails-only check; how to call it out as such?
  # Putting it in a "rails" checkset for now
  class StripFollowedByEmpty < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      @mycheck = MethodSequenceChecker.new(self, String, "strip", "empty?", MethodSequenceChecker::ARITY_TYPE_NONE, MethodSequenceChecker::ARITY_TYPE_NONE, true)
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
