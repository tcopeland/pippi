module Pippi::Checks

  class Check

    attr_accessor :ctx

    def initialize(ctx)
      @ctx = ctx
    end

    def array_mutator_methods
      (Array.new.methods.sort - Object.methods).select {|x| x.to_s =~ /!/ }
    end

  end
end
