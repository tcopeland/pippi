module Pippi::Checks

  class SelectFollowedByFirst < Check

    module MyFirst
      def first(elements=nil)
        result = if elements
          super(elements)
        else
          super()
        end
        unless elements
          problem_location = caller_locations.detect {|c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
          self.class._pippi_check_select_followed_by_first.add_problem(problem_location.lineno, problem_location.path)
        end
        result
      end
    end

    module MySelect
      def select(&blk)
        result = super
        if self.class._pippi_check_select_followed_by_first.nil?
          # Ignore Array subclasses since select or first may have difference meanings
        else
          result.extend Pippi::Checks::SelectFollowedByFirst::MyFirst
          [:collect!, :compact!, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!].each do |this_means_its_ok_sym|
            result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_first.its_ok_watcher_proc)
          end
        end
        result
      end
    end

    def its_ok_watcher_proc
      Proc.new do
        singleton_class.ancestors.detect {|x| x == Pippi::Checks::SelectFollowedByFirst::MyFirst }.instance_eval { remove_method :first }
        super()
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        @_pippi_check_select_followed_by_first = my_check
        def self._pippi_check_select_followed_by_first
          @_pippi_check_select_followed_by_first
        end
      end
      Array.prepend Pippi::Checks::SelectFollowedByFirst::MySelect
    end

    class Documentation
      def description
        "Don't use select followed by first; use detect instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.first"
      end
      def instead_use
        "[1,2,3].detect {|x| x > 1 }"
      end
    end

  end

end
