module Pippi
  class CheckSetMapper
    attr_reader :raw_check_specifier
    attr_accessor :predefined_sets

    def initialize(raw_check_specifier)
      @raw_check_specifier = raw_check_specifier
      define_standard_sets
    end

    def check_names
      raw_check_specifier.split(',').map do |specifier|
        predefined_sets[specifier] || specifier
      end.flatten
    end

    private

    def define_standard_sets
      @predefined_sets =
      {
        "basic" => [
          "SelectFollowedByFirst",
          "SelectFollowedBySize",
          "ReverseFollowedByEach",
        ],
        "training" => [
        ],
        "buggy" => [
          "AssertWithNil",
          "MapFollowedByFlatten",
        ]
      }
    end

  end
end
