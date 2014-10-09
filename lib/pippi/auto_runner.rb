module Pippi

  class AutoRunner
    attr_reader :ctx

    def initialize
      @ctx = Pippi::Context.new
      Pippi::CheckLoader.new(@ctx, "basic").checks.each(&:decorate)
      at_exit { dump }
      disable_rails_caching
    end

    def dump
      File.open("log/pippi.log", "w") do |outfile|
        @ctx.report.problems.each do |problem|
          outfile.syswrite("#{problem.to_text}\n")
        end
      end
    end

    def disable_rails_caching
      ActiveSupport::Cache::Store.class_eval do
        def write(*_)
        end
      end
    end

  end

end

