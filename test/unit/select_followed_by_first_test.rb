require 'test_helper'
require 'fileutils'

class SelectFollowedByFirstTest < MiniTest::Test

  def setup
    FileUtils.rm_f(output_file_name) if File.exists?(output_file_name)
  end

  def test_trivial_case_is_found
    execute_pippi_on foo_bar_code_sample("[1,2,3].select {|x| x > 2 }.first"), "SelectFollowedByFirst"
    assert_equal 1, load_report.size
  end

  def test_two_line_case_is_found
    execute_pippi_on foo_bar_code_sample("x = [1,2,3].select {|x| x > 2 } ; x.first"), "SelectFollowedByFirst"
    assert_equal 1, load_report.size
  end

  def test_rule_does_not_fire_if_no_first_call
    execute_pippi_on foo_bar_code_sample("[1,2,3].select {|x| x > 2 }"), "SelectFollowedByFirst"
    assert_equal 0, load_report.size
  end

  private

  def foo_bar_code_sample(code)
    CodeSample.new.tap {|c| c.code_text = "class Foo ; def bar ; #{code} ; end ; end" ; c.eval_to_execute = "Foo.new.bar" }
  end

  def execute_pippi_on(code, rule)
    tmp_file_name = "tmp/tmpfile.rb"
    File.open(tmp_file_name, "w") {|f| f.syswrite(code.code_text) }
    cmd = "bundle exec ruby bin/pippi #{tmp_file_name} #{rule} #{code.eval_to_execute} #{output_file_name}"
    IO.popen(cmd).close
  end

  def load_report
    File.read(output_file_name).split("\n")
  end

  def output_file_name
    "tmp/out.txt"
  end

end
