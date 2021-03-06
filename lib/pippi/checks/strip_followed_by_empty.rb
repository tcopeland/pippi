module Pippi::Checks

  # This is a Rails-only check; how to call it out as such?
  # Putting it in a "rails" checkset for now
  class StripFollowedByEmpty < Check

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self, String, MethodSequence.new("strip", "empty?"))
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
