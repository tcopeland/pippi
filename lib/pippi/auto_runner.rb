module Pippi

  class AutoRunner
    def initialize
      ctx = Pippi::Context.new(:report => Pippi::Report.new(Logger.new("log/pippi.log", "w")), :logger => self)
      Pippi::CheckLoader.new(ctx, "basic").checks.each(&:decorate)
    end
  end

end

