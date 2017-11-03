module Pippi::Checks

  class GsubWithBlank < Check

    module MyGsub
      def gsub(*args)
        if args.size == 2 && args[1].blank && !block_given?
          self.class._pippi_check_gsub_with_blank.add_problem
        end
        super
      end

    end

    def decorate
      if defined?(ActiveSupport)
        String.class_exec(self) do |my_check|
          @_pippi_check_gsub_with_blank = my_check
          class << self
            attr_reader :_pippi_check_gsub_with_blank
          end
          prepend Pippi::Checks::GsubWithBlank::MyGsub
        end
      end
    end

    def initialize(ctx)
      super

    end

    class Documentation
      def description
        "Don't use gsub to replace a String or Regex with an empty String; use remove instead"
      end

      def sample
        '"foo".gsub(/o/, "")'
      end

      def instead_use
        '"foo".remove("o")'
      end
    end
  end

end
