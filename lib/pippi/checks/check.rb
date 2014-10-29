module Pippi::Checks

  class Check

    attr_accessor :ctx

    def initialize(ctx)
      @ctx = ctx
    end

    def array_mutator_methods
      [:collect!, :compact!, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!]
    end

    def add_problem
      problem_location = caller_locations.detect {|c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
      ctx.report.add(Pippi::Problem.new(:line_number => problem_location.lineno, :file_path => problem_location.path, :check_class => self.class))
    end

    def clear_fault_proc(clz)
      Proc.new do |*args, &blk|
        problem_location = caller_locations.detect {|c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
        clz.clear_fault(problem_location.lineno, problem_location.path)
        super(*args, &blk)
      end
    end

    def clear_fault(lineno, path)
      ctx.report.remove(lineno, path, self.class)
    end

    def its_ok_watcher_proc(clazz, method_name)
      Proc.new do
        singleton_class.ancestors.detect {|x| x == clazz }.instance_eval { remove_method method_name }
        super()
      end
    end

  end
end
