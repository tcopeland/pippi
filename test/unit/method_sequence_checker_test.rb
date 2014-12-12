require "test_helper"

class MethodSequenceCheckerTest < MiniTest::Test

  class TestCheck < Pippi::Checks::Check
  end

  def test_decorate
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, Array, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    m.decorate
  end

end
