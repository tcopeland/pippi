module Pippi

  class CheckSetMapper

    attr_reader :raw_check_specifier

    def initialize(raw_check_specifier)
      @raw_check_specifier = raw_check_specifier
    end

    def check_names
      raw_check_specifier.split(",").map do |specifier|
        predefined_sets[specifier] || specifier
      end.flatten
    end

    private

    def predefined_sets
      {
        "basic" => [
          "SelectFollowedByFirst",
          "SelectFollowedBySize",
          "ReverseFollowedByEach",
          "AssertWithNil"
        ],
        "training" => [
        ],
        "buggy" => [
          "MapFollowedByFlatten",
        ]
      }
    end

  end
end
