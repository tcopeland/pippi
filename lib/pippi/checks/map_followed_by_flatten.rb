module Pippi::Checks

  class MapFollowedByFlatten < Check

    def flatten_watcher_proc
      Proc.new do |depth=1|
        result = super(depth)
        if depth < 2
          problem_location = caller_locations.detect {|c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
          self.class._pippi_check.add_problem(problem_location.lineno, problem_location.path)
        end
        result
      end
    end

    def its_ok_watcher_proc
      Proc.new do
        singleton_class.instance_eval { remove_method :flatten }
        super()
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        # How to do this without a class instance variable?
        @_pippi_check = my_check
        def self._pippi_check
          @_pippi_check
        end
        def map(&blk)
          result = super
          if self.class._pippi_check.nil?
            # Ignore Array subclasses since map or flatten may have difference meanings
          else
            result.define_singleton_method(:flatten, self.class._pippi_check.flatten_watcher_proc)
            [:select!, :sort].each do |this_means_its_ok_sym|
              result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check.its_ok_watcher_proc)
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
        "Don't use map followed by flatten; use flat_map instead"
      end
      def sample
        "[1,2,3].map {|x| [x,x+1] }.flatten"
      end
      def instead_use
        "[1,2,3].flat_map {|x| [x, x+1]}"
      end
    end

  end

end
