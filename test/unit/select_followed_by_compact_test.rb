require "test_helper"

class SelectFollowedByCompactTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "[1,2,nil].select {|x| x }.compact"
  end

  def test_no_error_if_no_compact_call
    assert_no_problems "[1,2,nil].select {|x| x }"
  end

  def test_duplicate_hits_are_not_recorded
    assert_problems "10.times { [1,2,nil].select {|x| x }.compact }"
  end

  def test_check_does_not_fire_if_compact_called_on_other_object
    assert_no_problems "y = [1,2,3].select {|x| x > 2 } ; z = [1,2] ; z.compact"
  end

  def test_intervening_method_call_prevents_report
    assert_no_problems "y = [1,2,3].select {|x| x > 2 } ; y.sort_by {|z| z+1} ; y.compact"
  end

  protected

  def check_for_test
    "SelectFollowedByCompact"
  end
end
