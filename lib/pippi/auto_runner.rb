module Pippi
  class AutoRunner
    attr_reader :ctx

    def initialize(opts = {})
      checkset = opts.fetch(:checkset, 'basic')
      @ctx = Pippi::Context.new

      @ctx.checks = Pippi::CheckLoader.new(@ctx, checkset).checks
      @ctx.checks.each(&:decorate)
      at_exit { dump }
    end

    def dump
      if @ctx.checks.one? && @ctx.checks.first.kind_of?(Pippi::Checks::MethodSequenceFinder)
        @ctx.checks.first.dump
      end
      File.open('log/pippi.log', 'w') do |outfile|
        @ctx.report.problems.each do |problem|
          outfile.syswrite("#{problem.to_text}\n")
        end
      end
    end
  end
end
