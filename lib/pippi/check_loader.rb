module Pippi

  class CheckLoader

    attr_reader :ctx
    attr_accessor :check_name

    def self.for_check_name(ctx, check_name)
      CheckLoader.new(ctx).tap do |check_loader|
        check_loader.check_name = check_name
      end
    end

    def initialize(ctx)
      @ctx = ctx
    end

    def check
      Pippi::Checks.const_get(check_name).new(ctx)
    end

  end
end
