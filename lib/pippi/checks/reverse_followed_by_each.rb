module Pippi::Checks

  class ReverseFollowedByEach < Check

    module MyEach
      def each
        result = super()
        problem_location = caller_locations.detect {|c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
        self.class._pippi_check_reverse_followed_by_each.add_problem(problem_location.lineno, problem_location.path)
        result
      end
    end

    module MyReverse
      def reverse
        result = super
        if self.class._pippi_check_reverse_followed_by_each.nil?
          # Ignore Array subclasses since reverse or each may have difference meanings
        else
          result.singleton_class.prepend MyEach
          self.class._pippi_check_reverse_followed_by_each.array_mutator_methods.each do |this_means_its_ok_sym|
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
        def self._pippi_check_reverse_followed_by_each
          @_pippi_check_reverse_followed_by_each
        end
      end
      Array.prepend MyReverse
    end

    class Documentation
      def description
        "Don't use each followed by reverse; use reverse_each instead"
      end
      def sample
        "[1,2,3].reverse.each {|x| x+1 }"
      end
      def instead_use
        "[1,2,3].reverse_each {|x| x+1 }"
      end
    end

  end

end
