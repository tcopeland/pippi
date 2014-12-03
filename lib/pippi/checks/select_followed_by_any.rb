module Pippi::Checks

  class SelectFollowedByAny < Check

    module MyAny
      def any?(&blk)
        self.class._pippi_check_select_followed_by_any.add_problem
        problem_location = caller_locations.find { |c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
        self.class._pippi_check_select_followed_by_any.method_names_that_indicate_this_is_being_used_as_a_collection.each do |this_means_its_ok_sym|
          define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_any.clear_fault_proc(self.class._pippi_check_select_followed_by_any, problem_location))
        end
        super
      end
    end

    module MySelect
      def select(&blk)
        result = super
        if self.class._pippi_check_select_followed_by_any.nil?
          # Ignore Array subclasses since select or any may have difference meanings
          # elsif defined?(ActiveRecord::Relation) && self.class.kind_of?(ActiveRecord::Relation) # maybe also this
        else
          result.extend MyAny
          self.class._pippi_check_select_followed_by_any.array_mutator_methods.each do |this_means_its_ok_sym|
            result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_any.its_ok_watcher_proc(MyAny, :any?))
          end
        end
        result
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        @_pippi_check_select_followed_by_any = my_check
        def self._pippi_check_select_followed_by_any
          @_pippi_check_select_followed_by_any
        end
        prepend MySelect
      end
    end

    class Documentation
      def description
        "Don't use select followed by any?; use any? with a block instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.any?"
      end
      def instead_use
        "[1,2,3].any? {|x| x > 1 }"
      end
    end

  end

end
