module Pippi::Checks

  class SelectFollowedBySelect < Check

    module MySecondSelect
      def select(&blk)
        self.class._pippi_check_select_followed_by_select.add_problem
        super
      end
    end

    module MyFirstSelect
      def select(&blk)
        result = super
        if !self.class._pippi_check_select_followed_by_select.nil?
          result.extend MySecondSelect
          self.class._pippi_check_select_followed_by_select.array_mutator_methods.each do |this_means_its_ok_sym|
            result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_select.its_ok_watcher_proc(MySecondSelect, :select))
          end
        end
        result
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        @_pippi_check_select_followed_by_select = my_check
        def self._pippi_check_select_followed_by_select
          @_pippi_check_select_followed_by_select
        end
        prepend MyFirstSelect
      end
    end

    class Documentation
      def description
        "Don't use consecutive select blocks; use a single select instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.select {|x| x > 2 }"
      end
      def instead_use
        "[1,2,3].select {|x| x > 2 }"
      end
    end

  end

end
