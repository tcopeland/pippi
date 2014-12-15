require "test_helper"

class MethodSequenceCheckerTest < MiniTest::Test

  class TestCheck < Pippi::Checks::Check
  end

  class SomeClass
    def select(&blk) ; [] ; end
    def size ; 0 ; end
  end
  class SomeClass2
    def select(&blk) ; [] ; end
    def size ; 0 ; end
  end
  class SomeClass3
    def select(&blk) ; [] ; end
    def size ; 0 ; end
  end

  module MyModule
    def size
      raise "boom"
    end
  end

  def test_decorate_should_add_accessor_to_decorated_class
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, SomeClass, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    m.decorate
    assert SomeClass._pippi_check_testcheck.kind_of?(TestCheck)
  end

  def test_decorate_should_add_a_module_that_decorates_the_first_method
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, SomeClass2, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MethodSequenceChecker::ARITY_TYPE_NONE, false)
    assert_equal SomeClass2.ancestors[0], SomeClass2
    m.decorate
    assert SomeClass2.ancestors[0] != SomeClass2
  end

  def test_accept_a_module_in_place_of_the_second_arity_type
    check = TestCheck.new(nil)
    m = MethodSequenceChecker.new(check, SomeClass3, "select", "size", MethodSequenceChecker::ARITY_TYPE_BLOCK_ARG, MyModule, false)
    m.decorate
    assert_equal("boom", assert_raises(RuntimeError) do
      SomeClass3.new.select {|x| }.size
    end.message)
  end

end
