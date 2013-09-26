require 'rubygems'

require 'pippi/checks/select_followed_by_first'

module Pippi

  class Runner

    attr_accessor :codefile, :rule, :code_to_eval, :output_file_name

    def initialize(args)
      # TODO use thor or whatever to parse args
      @codefile = args[0]
      @rule = args[1]
      @code_to_eval = args[2]
      @output_file_name = args[3]
    end

    def run
      ctx = {:report => []}
      Pippi::Checks.const_get(rule).new(ctx).register_tracepoint
      load "#{codefile}"
      eval @code_to_eval
      dump_report ctx
    end

    def dump_report(ctx)
      File.open(output_file_name, "w") do |outfile|
        ctx[:report].each do |finding|
          outfile.syswrite("#{finding}\n")
        end
      end
    end

  end

end

