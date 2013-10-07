require 'test_helper'

class SelectFollowedByFirstTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "[1,2,3].select {|x| x > 2 }.first"
  end

  def test_two_line_case_is_found
    assert_problems "x = [1,2,3].select {|x| x > 2 } ; x.first"
  end

  def test_check_does_not_fire_if_no_first_call
    assert_no_problems "[1,2,3].select {|x| x > 2 }"
  end

  def test_check_does_not_fire_if_first_called_on_other_object
    assert_no_problems "y = [1,2,3].select {|x| x > 2 } ; z = [1,2] ; z.first"
  end

  def test_intervening_method_call_prevents_report
    assert_no_problems "y = [1,2,3].select {|x| x > 2 } ; y.map {|z| z+1} ; y.first"
  end

  protected

  def check_for_test
    "SelectFollowedByFirst"
  end

end
