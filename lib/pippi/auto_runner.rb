module Pippi

  class AutoRunner
    attr_reader :ctx

    def initialize
      @ctx = Pippi::Context.new(:report => Pippi::Report.new(Logger.new("log/pippi.log", "w")), :logger => self)
      Pippi::CheckLoader.new(@ctx, "basic").checks.each(&:decorate)
      at_exit { dump }
    end

    def dump
      File.open("log/pippi.log", "w") do |outfile|
        @ctx.report.problems.each do |problem|
          outfile.syswrite("#{problem.to_text}\n")
        end
      end
    end

  end

end

