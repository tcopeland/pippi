# Note that Array#last doesn't take a block, so we can't
# do a similar rule recommending replacing:
# [1,2,3].select {|x| x > 1 }.last
# with
# [1,2,3].last {|x| x > 1 }
module Pippi::Checks
  class SelectFollowedByFirst < Check

    module MyModule
      def first(elements = nil)
        unless elements
          self.class._pippi_check_selectfollowedbyfirst.add_problem
        end
        if elements
          super(elements)
        else
          super()
        end
      end
    end

    def decorate
      @mycheck.decorate
    end

    def initialize(ctx)
      super
      check_descriptor = CheckDescriptor.new(self, Array, MethodSequence.new("select", "first", MyModule))
      @mycheck = MethodSequenceChecker.new(check_descriptor)
    end

    class Documentation
      def description
        "Don't use select followed by first; use detect instead"
      end

      def sample
        '[1,2,3].select {|x| x > 1 }.first'
      end

      def instead_use
        '[1,2,3].detect {|x| x > 1 }'
      end
    end
  end
end
