module Pippi::Checks

  class SelectFollowedByEmpty < Check

    module MyEmpty
      def empty?(&blk)
        self.class._pippi_check_select_followed_by_empty.add_problem
        self.class._pippi_check_select_followed_by_empty.method_names_that_indicate_this_is_being_used_as_a_collection.each do |this_means_its_ok_sym|
          define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_empty.clear_fault_proc(self.class._pippi_check_select_followed_by_empty))
        end
        super
      end
    end

    module MySelect
      def select(&blk)
        result = super
        if self.class._pippi_check_select_followed_by_empty.nil?
          # Ignore Array subclasses since select or empty may have difference meanings
          # elsif defined?(ActiveRecord::Relation) && self.class.kind_of?(ActiveRecord::Relation) # maybe also this
        else
          result.extend MyEmpty
          self.class._pippi_check_select_followed_by_empty.array_mutator_methods.each do |this_means_its_ok_sym|
            result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_empty.its_ok_watcher_proc(MyEmpty, :empty?))
          end
        end
        result
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        @_pippi_check_select_followed_by_empty = my_check
        def self._pippi_check_select_followed_by_empty
          @_pippi_check_select_followed_by_empty
        end
        prepend MySelect
      end
    end

    class Documentation
      def description
        "Don't use select followed by empty?; use none? instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.empty?"
      end
      def instead_use
        "[1,2,3].none? {|x| x > 1 }"
      end
    end

  end

end
