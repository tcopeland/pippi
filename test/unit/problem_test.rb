require "test_helper"

class ProblemTest < MiniTest::Test

  def test_eql_should_say_equal_things_are_equal
    p1 = Pippi::Problem.new(:file_path => "foo", :line_number => 42, :check_class => "String")
    p2 = Pippi::Problem.new(:file_path => "foo", :line_number => 42, :check_class => "String")
    assert p1.eql?(p2)
    assert p2.eql?(p1)
  end

  def test_eql_should_say_unequal_things_are_unequal
    p1 = Pippi::Problem.new(:file_path => "foo", :line_number => 42, :check_class => "String")
    p2 = Pippi::Problem.new(:file_path => "foo", :line_number => 43, :check_class => "String")
    assert !p1.eql?(p2)
    assert !p2.eql?(p1)
    p3 = Pippi::Problem.new(:file_path => "foo2", :line_number => 42, :check_class => "String")
    assert !p1.eql?(p3)
    p4 = Pippi::Problem.new(:file_path => "foo", :line_number => 42, :check_class => "Array")
    assert !p1.eql?(p4)
  end

end
