require 'test_helper'

class MapFollowedByFlattenTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "[1,2,3].map {|x| [x,x+1] }.flatten"
  end

  def test_requires_first_call_be_to_map
    assert_no_problems "[1,2,3].select {|x| [x,x+1] }.flatten"
  end

  def test_requires_last_call_be_to_flatten
    assert_no_problems "[1,2,3].map {|x| [x] }.first"
  end

  def test_works_across_statements
    assert_problems "tmp = [1,2,3].map {|x| [x] } ; tmp.flatten"
  end

  def test_does_not_work_if_arg_to_flatten_is_more_than_one
    assert_no_problems "[1,2,3].map {|x| [x] }.flatten(2)"
  end

  protected

  def check_for_test
    "MapFollowedByFlatten"
  end

end
