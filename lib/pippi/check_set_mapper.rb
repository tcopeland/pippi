module Pippi
  # Groups {Pippi::Checks::Check} into sets that can be referenced by a key name
  class CheckSetMapper
    attr_reader :raw_check_specifier
    attr_accessor :predefined_sets

    # @param [String] raw_check_specifier either a single key or a comma-separated
    #   collection of keys used to lookup a set of {Pippi::Checks::Check}
    #
    # @example A single key
    #   Pippi::CheckSetMapper.new('basic')
    #
    # @example A collection of keys
    #   Pippi::CheckSetMapper.new('basic,rails')
    def initialize(raw_check_specifier)
      @raw_check_specifier = raw_check_specifier
      define_standard_sets
    end

    # @return [Array<String>] all of the names of {Pippi::Checks::Check} that the
    #   keys correspond to
    def check_names
      raw_check_specifier.split(',').map do |specifier|
        predefined_sets[specifier] || specifier
      end.flatten
    end

    private

    # :nodoc:
    def define_standard_sets
      @predefined_sets =
      {
        "basic" => [
          "SelectFollowedByFirst",
          "SelectFollowedBySize",
          "SelectFollowedByAny",
          "SelectFollowedByNone",
          "SelectFollowedByEmpty",
          "ReverseFollowedByEach",
          "SelectFollowedBySelect"
        ],
        "rails" => [
          "StripFollowedByEmpty"
        ],
        "training" => [
        ],
        "research" => [
          "MethodSequenceFinder",
        ],
        "buggy" => [
          "AssertWithNil",
          "MapFollowedByFlatten",
        ]
      }
    end

  end
end
