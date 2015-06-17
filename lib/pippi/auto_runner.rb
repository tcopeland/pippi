module Pippi
  # Main entry point. Run Pippi checks and report issues
  class AutoRunner
    attr_reader :ctx

    # Runs Pippi. Checks source for problems and reports any problems it finds.
    # @param [Hash] opts
    # @option opts [String, Array<String>] :checkset determines the set of
    #   {Pippi::Check} to use (see {Pippi::CheckLoader})
    # @option opts [IO] :io the IO to push problems to
    def initialize(opts = {})
      checkset = opts.fetch(:checkset, 'basic')
      @io = opts.fetch(:io) { File.open('log/pippi.log', 'w') }
      @ctx = Pippi::Context.new

      @ctx.checks = Pippi::CheckLoader.new(@ctx, checkset).checks
      @ctx.checks.each(&:decorate)
      at_exit { dump }
    end

    # Report any problems found by any of the checks
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
