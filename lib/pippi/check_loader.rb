module Pippi
  # Used to load a set of {Pippi::Checks::Check} by keys (see
  # {Pippi::CheckSetMapper})
  class CheckLoader
    attr_reader :ctx, :check_names

    # @param [Pippi::Context] ctx struct used for the run
    # @param [String, Array<String>] check_names either a key used by
    #   {Pippi::CheckSetMapper} to lookup check names or a collection of check
    #   names
    def initialize(ctx, check_names)
      @ctx = ctx
      @check_names = if check_names.is_a?(String)
                       Pippi::CheckSetMapper.new(check_names).check_names
      else
        check_names
      end
    end

    # @return [Array<Pippi::Checks::Check>] the collection of {Pippi::Checks::Check}
    #   that the keys or check names correspond to
    def checks
      check_names.map do |check_name|
        Pippi::Checks.const_get(check_name).new(ctx)
      end
    end
  end
end
