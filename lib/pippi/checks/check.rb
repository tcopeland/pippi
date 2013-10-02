module Pippi::Checks

  class Check

    attr_accessor :ctx

    def initialize(ctx)
      # TODO make a PippiContext
      @ctx = ctx
    end


  end
end
