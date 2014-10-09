module Pippi

  class Report

    attr_reader :problems

    def initialize
      @problems = []
    end

    def add(problem)
      @problems << problem unless duplicate_report?(problem)
    end

    private

    def duplicate_report?(candidate)
      !problems.detect {|existing| existing.eql?(candidate) }.nil?
    end

  end

end
