module Pippi

  class ExecRunner

    attr_accessor :codefile, :check_name, :code_to_eval, :output_file_name

    def initialize(args)
      check_args(args)
      @codefile = args[0]
      @check_name = args[1]
      @code_to_eval = args[2]
      @output_file_name = args[3]
    end

    def run
      ctx = Pippi::Context.new
      CheckLoader.new(ctx, check_name).checks.each do |check|
        check.decorate
      end
      load "#{codefile}"
      eval code_to_eval
      dump_report ctx
    end

    def dump_report(ctx)
      File.open(output_file_name, "w") do |outfile|
        ctx.report.problems.each do |problem|
          outfile.syswrite("#{problem.to_text}\n")
        end
      end
    end

    private

    def check_args(args)
      begin
        raise ArgumentError if args.size != 4
      rescue ArgumentError => e
        puts "ERROR: wrong number of arguments"
        puts "Use: pippi code_file check_name eval_string output_file"
        exit 1
      end
    end

  end

end
