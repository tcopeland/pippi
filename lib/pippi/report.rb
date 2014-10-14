module Pippi

  class Report

    attr_reader :problems

    def initialize
      @problems = []
    end

    def add(problem)
      @problems << problem unless duplicate_report?(problem)
    end

    def remove(lineno, path)
      @problems.reject! {|p| p.line_number == lineno && p.file_path == path }
    end

    private

    def duplicate_report?(candidate)
      !problems.detect {|existing| existing.eql?(candidate) }.nil?
    end

  end

end
