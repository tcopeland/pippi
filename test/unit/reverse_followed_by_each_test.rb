require "test_helper"

class ReverseFollowedByEachTest < CheckTest

  def test_reverse_still_works
    assert_no_problems "raise 'bang' unless [1,2,3].reverse == [3,2,1]"
  end

  def test_canonical_case_is_found
    assert_problems "[1,2,3].reverse.each {|x| x }"
  end

  def test_requires_first_call_be_to_reverse
    assert_no_problems "[1,2,3].sort.each{|x| [x,x+1] }"
  end

  def test_requires_last_call_be_to_each
    assert_no_problems "[1,2,3].reverse.select {|x| [x] }"
  end

  def test_works_across_statements
    assert_problems "tmp = [1,2,3].reverse ; tmp.each {|x| [x] }"
  end

  def test_will_not_flag_if_mutator_invoked
    assert_no_problems "t = [1,2,3].reverse ;  t.sort! ; t.each {|x| x }"
  end

  protected

  def check_for_test
    "ReverseFollowedByEach"
  end

end
