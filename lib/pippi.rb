require 'rubygems'

require 'pippi/report'
require 'pippi/tracepoint_listener'
require "pippi/checks/check"
require 'pippi/problem'
require 'pippi/checks/select_followed_by_first'
require 'pippi/checks/select_followed_by_compact'

module Pippi

  class Runner

    attr_accessor :codefile, :rule_name, :code_to_eval, :output_file_name

    def initialize(args)
      # TODO use thor or whatever to parse args
      @codefile = args[0]
      @rule_name = args[1]
      @code_to_eval = args[2]
      @output_file_name = args[3]
    end

    def run
      ctx = {:report => Pippi::Report.new, :logger => self}
      rule = Pippi::Checks.const_get(rule_name).new(ctx)
      @tracepoint_listener = TracepointListener.new(rule)
      load "#{codefile}"
      eval code_to_eval
      dump_report ctx
    end

    def dump_report(ctx)
      File.open(output_file_name, "w") do |outfile|
        ctx[:report].problems.each do |problem|
          outfile.syswrite("#{problem.to_text}\n")
        end
      end
    end

    def log(str)
      File.open("pippi.log", "a") {|f| f.syswrite("#{Time.now}: #{str}\n")}
    end

  end

end

