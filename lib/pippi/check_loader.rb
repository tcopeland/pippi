module Pippi
  class CheckLoader
    attr_reader :ctx, :check_names

    def initialize(ctx, check_names)
      @ctx = ctx
      @check_names = if check_names.is_a?(String)
                       Pippi::CheckSetMapper.new(check_names).check_names
      else
        check_names
      end
    end

    def checks
      check_names.map do |check_name|
        Pippi::Checks.const_get(check_name).new(ctx)
      end
    end
  end
end
