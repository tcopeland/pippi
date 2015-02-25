module Pippi::Checks

  # TODO make this use MethodSequenceChecker
  class ReverseFollowedByEach < Check
    module MyEach
      def each
        self.class._pippi_check_reverse_followed_by_each.add_problem
        super()
      end
    end

    module MyReverse
      def reverse
        result = super
        if self.class._pippi_check_reverse_followed_by_each.nil?
          # Ignore Array subclasses since reverse or each may have difference meanings
        else
          result.singleton_class.class_eval { prepend MyEach }
          self.class._pippi_check_reverse_followed_by_each.mutator_methods.each do |this_means_its_ok_sym|
            result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_reverse_followed_by_each.its_ok_watcher_proc(MyEach, :each))
          end
        end
        result
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        # How to do this without a class instance variable?
        @_pippi_check_reverse_followed_by_each = my_check
        class << self
          attr_reader :_pippi_check_reverse_followed_by_each
        end
        prepend MyReverse
      end
    end

    class Documentation
      def description
        "Don't use reverse followed by each; use reverse_each instead"
      end

      def sample
        '[1,2,3].reverse.each {|x| x+1 }'
      end

      def instead_use
        '[1,2,3].reverse_each {|x| x+1 }'
      end
    end
  end
end
