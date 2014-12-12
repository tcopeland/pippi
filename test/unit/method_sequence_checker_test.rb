require "test_helper"

class MethodSequenceCheckerTest < MiniTest::Test

  class TestCheck < Pippi::Checks::Check
  end

  def test_decorate_should_add_accessor_to_decorated_class
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, Array, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    m.decorate
    assert Array._pippi_check_testcheck.kind_of?(TestCheck)
  end

  def test_decorate_should_add_a_module_that_decorates_the_first_method
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, Array, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    assert_equal Array.ancestors[0], Array
    m.decorate
    assert Array.ancestors[0] != Array
  end

end
