require 'test_helper'

class DetectFollowedByNilTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "[1,2,3].detect {|x| x > 2 }.nil?"
  end

  # def test_rails_case_is_found
  #   assert_problems "[1,2,3].detect {|x| x > 2 }.present?", :include_rails_core_extensions => true
  # end

  def test_two_statement_case_is_found
    assert_problems "x = [1,2,3].detect {|x| x > 2 } ; x.nil?"
  end

  def test_check_does_not_fire_if_no_first_call
    assert_no_problems "[1,2,3].detect {|x| x > 2 }"
  end

  def test_check_does_not_fire_if_first_called_on_other_object
    assert_no_problems "y = [1,2,3].detect {|x| x > 2 } ; z = [1,2] ; z.nil?"
  end

  def test_intervening_method_call_prevents_report
    assert_no_problems "y = [1,2,3].detect {|x| x > 2 } ; y.to_s ; y.nil?"
  end

  protected

  def check_for_test
    "DetectFollowedByNil"
  end

end
