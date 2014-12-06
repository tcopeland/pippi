module Pippi::Checks
  class SelectFollowedByFirst < Check

    # TODO make this use MethodSequenceChecker
    module MyFirst
      def first(elements = nil)
        unless elements
          self.class._pippi_check_select_followed_by_first.add_problem
        end
        if elements
          super(elements)
        else
          super()
        end
      end
    end

    module MySelect
      def select(&blk)
        result = super
        if self.class._pippi_check_select_followed_by_first.nil?
          # Ignore Array subclasses since select or first may have difference meanings
        else
          result.extend MyFirst
          self.class._pippi_check_select_followed_by_first.array_mutator_methods.each do |this_means_its_ok_sym|
            result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_first.its_ok_watcher_proc(MyFirst, :first))
          end
        end
        result
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        @_pippi_check_select_followed_by_first = my_check
        class << self
          attr_reader :_pippi_check_select_followed_by_first
        end
        prepend MySelect
      end
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
