require 'test_helper'

class SelectFollowedByFirstTest < MiniTest::Test

  # def foo
  #   x = [1,2,3].select {|x| x > 1}
  #   [1,2].first
  # end
  #
  # def foo2
  #   [1,2,3].select {|x| x > 1}.first
  # end
  #
  # f = SelectFollowedByFirstFinder .new
  # f.register_tracepoint
  # puts "should not find one"
  # foo
  # puts "should find one"
  # foo2
  # puts "should not find one"
  # foo

  def test_trivial_case_is_found
    code = CodeSample.new(:code_text => "class Foo ; def bar ; [1,2,3].select {|x| x > 2 }.first ; end ; end", :eval_to_execute => "Foo.new.bar")
    execute_pippi_on code, "SelectFollowedByFirst"
    report = load_report
    assert_equal 1, report.size
  end

  def execute_pippi_on(code, rule)
    tmp_file_name = "tmp/tmpfile.rb"
    File.open(tmp_file_name, "w") {|f| f.syswrite(code) }
    IO.popen("bundle exec ruby bin/pippi #{tmp_file_name} #{rule} Foo.new.bar #{output_file_name}")
  end

  def load_report
    File.read(output_file_name).split("\n")
  end

  def output_file_name
    "tmp/out.txt"
  end

end
