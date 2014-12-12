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
      @mycheck = MethodSequenceChecker.new(self, Array, "select", "first", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MyModule, true)
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
