module Pippi
  class Problem

    attr_accessor :file_path, :line_number, :rule_class

    def initialize(opts)
      @file_path = opts[:file_path]
      @rule_class = opts[:rule_class]
      @line_number = opts[:line_number]
    end

    # TODO probably need various reporting formats
    def to_text
      "#{file_path},#{rule_class.name.split('::').last},#{line_number}"
    end
  end
end
