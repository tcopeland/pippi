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
      check_descriptor = CheckDescriptor.new(self)
      check_descriptor.clazz_to_decorate = Array
      check_descriptor.method1 = "select"
      check_descriptor.method2 = "first"
      check_descriptor.first_method_arity_type = MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG
      check_descriptor.second_method_arity_type = MyModule
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
