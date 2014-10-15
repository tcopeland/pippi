module Pippi::Checks

  class SelectFollowedBySize < Check

    def size_watcher_proc
      Proc.new do
        result = super()
        problem_location = caller_locations.detect {|c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
        self.class._pippi_check_select_followed_by_size.add_problem(problem_location.lineno, problem_location.path)
        [:sort!].each do |this_means_its_ok_sym|
          define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_size.clear_fault_proc(problem_location.lineno, problem_location.path))
        end
        result
      end
    end

    def clear_fault_proc(lineno, path)
      Proc.new do
        self.class._pippi_check_select_followed_by_size.clear_fault(lineno, path)
      end
    end

    def clear_fault(lineno, path)
      ctx.report.remove(lineno, path, self.class)
    end

    def its_ok_watcher_proc
      Proc.new do
        singleton_class.instance_eval { remove_method :size }
        super()
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        @_pippi_check_select_followed_by_size = my_check
        def self._pippi_check_select_followed_by_size
          @_pippi_check_select_followed_by_size
        end
        def select(&blk)
          result = super
          if self.class._pippi_check_select_followed_by_size.nil?
            # Ignore Array subclasses since select or size may have difference meanings
          else
            result.define_singleton_method(:size, self.class._pippi_check_select_followed_by_size.size_watcher_proc)
            # not using Check#array_mutator_methods because calling that does... something.
            [:collect!, :compact!, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!].each do |this_means_its_ok_sym|
              result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_select_followed_by_size.its_ok_watcher_proc)
            end
          end
          result
        end
      end
    end

    def add_problem(line_number, file_path)
      ctx.report.add(Pippi::Problem.new(:line_number => line_number, :file_path => file_path, :check_class => self.class))
    end

    class Documentation
      def description
        "Don't use select followed by size; use count instead"
      end
      def sample
        "[1,2,3].select {|x| x > 1 }.size"
      end
      def instead_use
        "[1,2,3].count {|x| x > 1 }"
      end
    end

  end

end
