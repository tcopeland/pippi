module Pippi
  class Report
    attr_reader :problems, :removed

    def initialize
      @problems = []
      @removed = Set.new
    end

    def add(problem)
      @problems << problem unless duplicate_report?(problem) || already_removed?(problem)
    end

    def remove(lineno, path, clazz)
      @removed << Pippi::Problem.new(:line_number => lineno, :file_path => path, :check_class => clazz).to_s
      @problems.reject! { |p| p.line_number == lineno && p.file_path == path && p.check_class == clazz }
    end

    private

    def duplicate_report?(candidate)
      !problems.find { |existing| existing.eql?(candidate) }.nil?
    end

    def already_removed?(problem)
      removed.include?(problem.to_s)
    end

  end
end
