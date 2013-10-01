require 'test_helper'
require 'fileutils'

class SelectFollowedByFirstTest < MiniTest::Test

  def test_canonical_case_is_found
    assert_equal 1, execute_pippi_on(foo_bar_code_sample("[1,2,3].select {|x| x > 2 }.first")).size
  end

  def test_two_line_case_is_found
    assert_equal 1, execute_pippi_on(foo_bar_code_sample("x = [1,2,3].select {|x| x > 2 } ; x.first")).size
  end

  def test_rule_does_not_fire_if_no_first_call
    assert execute_pippi_on(foo_bar_code_sample("[1,2,3].select {|x| x > 2 }")).empty?
  end

  private

  def foo_bar_code_sample(code)
    CodeSample.new.tap {|c| c.code_text = "class Foo ; def bar ; #{code} ; end ; end" ; c.eval_to_execute = "Foo.new.bar" }
  end

  def execute_pippi_on(code)
    File.open(tmp_code_sample_file_name, "w") {|f| f.syswrite(code.code_text) }
    cmd = "bundle exec ruby bin/pippi #{tmp_code_sample_file_name} #{rule_for_test} #{code.eval_to_execute} #{output_file_name}"
    IO.popen(cmd).close
    report = File.read(output_file_name).split("\n")
    FileUtils.rm_f(output_file_name) if File.exists?(output_file_name)
    report
  end

  def rule_for_test
    "SelectFollowedByFirst"
  end

  def output_file_name
    "tmp/out.txt"
  end

  def tmp_code_sample_file_name
    "tmp/tmpfile.rb"
  end

end
