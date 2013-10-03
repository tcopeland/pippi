module Pippi

  class Context

    attr_reader :report, :logger

    def initialize(opts)
      @report = opts[:report]
      @logger = opts[:logger]
    end

  end

end
