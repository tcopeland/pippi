module Pippi::Checks

  class Check

    attr_accessor :ctx

    def initialize(ctx)
      @ctx = ctx
    end

    def array_mutator_methods
      [:collect!, :compact!, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!]
    end

    def add_problem(line_number, file_path)
      ctx.report.add(Pippi::Problem.new(:line_number => line_number, :file_path => file_path, :check_class => self.class))
    end

  end
end
