require "test_helper"

class ReportTest < MiniTest::Test

  def test_can_add_a_problem
    report = Pippi::Report.new
    report.add(Pippi::Problem.new(:file_path => "foo", :line_number => 42, :check_class => Pippi::Checks::SelectFollowedByFirst))
    assert_equal 1, report.problems.size
  end
  
  def test_filters_duplicates
    report = Pippi::Report.new
    report.add(Pippi::Problem.new(:file_path => "foo", :line_number => 42, :check_class => Pippi::Checks::SelectFollowedByFirst))
    report.add(Pippi::Problem.new(:file_path => "foo", :line_number => 42, :check_class => Pippi::Checks::SelectFollowedByFirst))
    assert_equal 1, report.problems.size
  end
  
  def test_can_remove_problem
    report = Pippi::Report.new
    report.add(Pippi::Problem.new(:file_path => "foo", :line_number => 42, :check_class => Pippi::Checks::SelectFollowedByFirst))
    report.remove 42, "foo", Pippi::Checks::SelectFollowedByFirst
    assert report.problems.empty?
  end
  
end