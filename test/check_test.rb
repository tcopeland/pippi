require 'tempfile'

class CheckTest < MiniTest::Test

  CodeSample = Struct.new(:code_text, :eval_to_execute)

  def assert_no_problems(str, opts={})
    assert execute_pippi_on(foo_bar_code_sample(str, opts[:subclass] || ""), opts).empty?
  end

  def assert_problems(str, opts={})
    assert_equal opts[:count] || 1, execute_pippi_on(foo_bar_code_sample(str, opts[:subclass] || ""), opts).size
  end

  def output_file_name
    @output_file_name ||= Tempfile.new("pippi_output").path
  end

  def tmp_code_sample_file_name
    @tmp_code_sample_file_name ||= Tempfile.new("pippi_codesample").path
  end

  def foo_bar_code_sample(code, subclass="")
    CodeSample.new.tap {|c| c.code_text = "class Foo #{subclass.size > 0 ? "< #{subclass}" : ""}; def bar ; #{code} ; end ; end" ; c.eval_to_execute = "Foo.new.bar" }
  end

  def execute_pippi_on(code, opts={})
    File.open(tmp_code_sample_file_name, "w") {|f| f.syswrite(code.code_text) }
    maybe_extensions = opts[:include_rails_core_extensions].nil? ? "" : "-r#{Dir.pwd}/test/rails_core_extensions.rb"
    cmd = "bundle exec ruby #{maybe_extensions} bin/pippi #{tmp_code_sample_file_name} #{check_for_test} #{code.eval_to_execute} #{output_file_name}"
    IO.popen(cmd).close
    report = File.read(output_file_name).split
    FileUtils.rm_f(output_file_name) if File.exists?(output_file_name)
    report
  end

  def check_for_test
    self.class.name.sub(/Test/, "")
  end

end
