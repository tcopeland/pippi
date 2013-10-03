module Pippi

  class Report

    attr_reader :problems, :logger

    def initialize(logger=nil)
      @problems = []
      @logger = logger
    end

    def add(problem)
      if !duplicate_report?(problem)
        @problems << problem
        if logger
          logger.warn problem.to_text
        end
      end
    end

    private

    def duplicate_report?(candidate)
      !problems.detect {|existing| existing.eql?(candidate) }.nil?
    end

  end

end
