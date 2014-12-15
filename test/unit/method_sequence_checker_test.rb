require "test_helper"

class MethodSequenceCheckerTest < MiniTest::Test

  class TestCheck < Pippi::Checks::Check
  end

  class SomeClass
    def select(&blk)
      []
    end
    def size
      0
    end
  end
  class SomeClass2
    def select(&blk)
      []
    end
    def size
      0
    end
  end

  def test_decorate_should_add_accessor_to_decorated_class
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, SomeClass2, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    m.decorate
    assert SomeClass2._pippi_check_testcheck.kind_of?(TestCheck)
  end

  def test_decorate_should_add_a_module_that_decorates_the_first_method
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, SomeClass, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    assert_equal SomeClass.ancestors[0], SomeClass
    m.decorate
    assert SomeClass.ancestors[0] != SomeClass
  end

end
