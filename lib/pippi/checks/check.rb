module Pippi::Checks

  class Check

    attr_accessor :ctx

    def initialize(ctx)
      @ctx = ctx
    end

    def array_mutator_methods
      [:collect!, :compact!, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!]
    end

  end
end
