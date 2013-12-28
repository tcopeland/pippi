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

  protected

  def check_for_test
    "MapFollowedByFlatten"
  end

end
