module Pippi
  class Problem
    attr_accessor :file_path, :line_number, :check_class

    def initialize(opts)
      @file_path = opts[:file_path]
      @check_class = opts[:check_class]
      @line_number = opts[:line_number]
    end

    # TODO probably need various reporting formats
    def to_text
      "#{file_path},#{check_class.name.split('::').last},#{line_number}"
    end

    # TODO correct method?
    def eql?(other)
      file_path == other.file_path &&
      check_class == other.check_class &&
      line_number == other.line_number
    end

    def to_s
      "#{file_path},#{check_class.name.split('::').last},#{line_number}"
    end
  end
end
