require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'

CodeSample = Struct.new(:code_text, :eval_to_execute)

def foo_bar_code_sample(code)
  CodeSample.new.tap {|c| c.code_text = "class Foo ; def bar ; #{code} ; end ; end" ; c.eval_to_execute = "Foo.new.bar" }
end

def execute_pippi_on(code)
  File.open(tmp_code_sample_file_name, "w") {|f| f.syswrite(code.code_text) }
  cmd = "bundle exec ruby bin/pippi #{tmp_code_sample_file_name} #{check_for_test} #{code.eval_to_execute} #{output_file_name}"
  IO.popen(cmd).close
  report = File.read(output_file_name).split("\n")
  FileUtils.rm_f(output_file_name) if File.exists?(output_file_name)
  report
end

class CheckTest < MiniTest::Test

  def assert_no_problems(str)
    assert execute_pippi_on(foo_bar_code_sample(str)).empty?
  end

  def assert_problems(str, count=1)
    assert_equal count, execute_pippi_on(foo_bar_code_sample(str)).size
  end

  def output_file_name
    "tmp/out.txt"
  end

  def tmp_code_sample_file_name
    "tmp/tmpfile.rb"
  end

end
