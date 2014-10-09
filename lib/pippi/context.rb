module Pippi

  class Context

    class DebugLogger
      def warn(str)
        File.open("pippi_debug.log", "a") do |f|
          f.syswrite("#{str}\n")
        end
      end
    end

    class NullLogger
      def warn(str)
      end
    end

    attr_reader :report, :debug_logger

    def initialize
      @report = Pippi::Report.new
      @debug_logger = if ENV['PIPPI_DEBUG']
        Pippi::Context::DebugLogger.new
      else
        Pippi::Context::NullLogger.new
      end
    end

  end

end
