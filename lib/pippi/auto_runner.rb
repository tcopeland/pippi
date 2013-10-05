require 'pippi'

module Pippi

  class AutoRunner
  end

  class MyLogger
    def warn(str)
      File.open("pippi.log", "a") do |f|
        f.syswrite("#{str}\n")
      end
    end
  end

  # More logging terribleness, TODO clean all this up
  class DebugLogger
    def warn(str)
      File.open("pippi_debug.log", "a") do |f|
        f.syswrite("#{str}\n")
      end
    end
  end

end

TracepointListener.new(Pippi::CheckLoader.for_check_name(Pippi::Context.new({:report => Pippi::Report.new(Pippi::MyLogger.new), :logger => Pippi::DebugLogger.new}), "SelectFollowedByFirst").check)
