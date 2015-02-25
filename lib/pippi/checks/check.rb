module Pippi::Checks
  class Check
    attr_accessor :ctx

    def initialize(ctx)
      @ctx = ctx
    end

    def mutator_methods(the_type=Array)
      if the_type == String
        [:insert, :<<]
      else
        [:collect!, :compact!, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!]
      end
    end

    def method_names_that_indicate_this_is_being_used_as_a_collection
      [:collect!, :compact!, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!, :collect, :compact, :first, :flatten, :join, :last, :map, :reject, :reverse, :rotate, :select, :shuffle, :slice, :sort, :sort_by, :uniq]
    end

    def add_problem
      problem_location = caller_locations.find { |c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
      ctx.report.add(Pippi::Problem.new(line_number: problem_location.lineno, file_path: problem_location.path, check_class: self.class))
    end

    def clear_fault_proc(clz, problem_location)
      proc do |*args, &blk|
        clz.clear_fault(problem_location.lineno, problem_location.path)
        super(*args, &blk)
      end
    end

    def clear_fault(lineno, path)
      ctx.report.remove(lineno, path, self.class)
    end

    def its_ok_watcher_proc(clazz, method_name)
      proc do |*args, &blk|
        begin
          singleton_class.ancestors.find { |x| x == clazz }.instance_eval { remove_method method_name }
        rescue NameError
          return super(*args, &blk)
        else
          return super(*args, &blk)
        end
      end
    end
  end
end
