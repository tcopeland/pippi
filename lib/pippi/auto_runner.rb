module Pippi

  class AutoRunner
    attr_reader :ctx

    def initialize
      @ctx = Pippi::Context.new
      Pippi::CheckLoader.new(@ctx, "basic").checks.each(&:decorate)
      at_exit { dump }
      maybe_disable_rails_caching
    end

    def dump
      File.open("log/pippi.log", "w") do |outfile|
        @ctx.report.problems.each do |problem|
          outfile.syswrite("#{problem.to_text}\n")
        end
      end
    end

    def maybe_disable_rails_caching
      if defined?(ActiveSupport::Cache::Store)
        ActiveSupport::Cache::Store.class_eval do
          def write(*_)
          end
        end
      end
    end

  end

end

