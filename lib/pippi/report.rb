module Pippi

  class Report

    attr_reader :problems

    def initialize
      @problems = []
    end

    def add(problem)
      @problems << problem
    end

  end

end
