module Pippi
  class AutoRunner
    attr_reader :ctx

    def initialize(opts = {})
      checkset = opts.fetch(:checkset, 'basic')
      @ctx = Pippi::Context.new
      Pippi::CheckLoader.new(@ctx, checkset).checks.each(&:decorate)
      at_exit { dump }
    end

    def dump
      File.open('log/pippi.log', 'w') do |outfile|
        @ctx.report.problems.each do |problem|
          outfile.syswrite("#{problem.to_text}\n")
        end
      end
    end
  end
end
