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
      check_descriptor.first_method_descriptor = MethodDescriptor.new("select")
      check_descriptor.second_method_descriptor = MethodDescriptor.new("first", MyModule)
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
