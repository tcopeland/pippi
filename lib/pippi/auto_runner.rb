module Pippi
  class AutoRunner
    attr_reader :ctx

    def initialize(opts = {})
      checkset = opts.fetch(:checkset, 'basic')
      @io = opts.fetch(:io, File.open('log/pippi.log', 'w'))
      @ctx = Pippi::Context.new

      @ctx.checks = Pippi::CheckLoader.new(@ctx, checkset).checks
      @ctx.checks.each(&:decorate)
      at_exit { dump }
    end

    def dump
      if @ctx.checks.one? && @ctx.checks.first.kind_of?(Pippi::Checks::MethodSequenceFinder)
        @ctx.checks.first.dump
      end
      @ctx.report.problems.each do |problem|
        @io.puts(problem.to_text)
      end
    end
  end
end
