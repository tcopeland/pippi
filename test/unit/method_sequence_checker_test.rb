require "test_helper"

class MethodSequenceCheckerTest < MiniTest::Test

  class TestCheck < Pippi::Checks::Check ; end

  def setup
    @clz_to_be_checked = Class.new do
      def select(&blk) ; self ; end
      def size ; 0 ; end
    end
  end

  def test_decorate_should_add_accessor_to_decorated_class
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, @clz_to_be_checked, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    m.decorate
    assert @clz_to_be_checked._pippi_check_testcheck.kind_of?(TestCheck)
  end

  def test_decorate_should_add_a_module_that_decorates_the_first_method
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, @clz_to_be_checked, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    assert_equal @clz_to_be_checked.ancestors[0], @clz_to_be_checked
    m.decorate
    assert @clz_to_be_checked.ancestors[0] != @clz_to_be_checked
  end

  def test_accept_a_module_in_place_of_the_second_arity_type
    mymodule = Module.new do
      def size
        raise "boom"
      end
    end
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, @clz_to_be_checked, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, mymodule, false)
    m.decorate
    assert_equal("boom", assert_raises(RuntimeError) do
      @clz_to_be_checked.new.select {|x| }.size
    end.message)
  end

  def test_add_a_problem_if_method_sequence_is_detected
    ctx = Pippi::Context.new
    check = TestCheck.new(ctx)
    m = MethodSequenceChecker.new(check, @clz_to_be_checked, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    m.decorate
    @clz_to_be_checked.new.select {|x| x }.size
    assert ctx.report.problems.one?
    problem = ctx.report.problems.first
    assert_match /method_sequence_checker_test.rb/, problem.file_path
    assert_match /TestCheck/, problem.check_class.name
    assert problem.line_number > 0
  end

  def test_no_problem_added_if_method_sequence_not_detected
    ctx = Pippi::Context.new
    check = TestCheck.new(ctx)
    m = MethodSequenceChecker.new(check, @clz_to_be_checked, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    m.decorate
    @clz_to_be_checked.new.select {|x| x }.select
    assert ctx.report.problems.none?
  end

end
