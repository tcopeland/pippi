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

end

TracepointListener.new(Pippi::CheckLoader.new(Pippi::Context.new({:report => Pippi::Report.new(Pippi::MyLogger.new)}), "basic").checks)
