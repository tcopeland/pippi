require 'test_helper'

class SelectFollowedBySelectTest < CheckTest
  def test_canonical_case_is_found
    assert_problems '[1,2,3].select {|x| x > 1 }.select {|x| x > 2 }'
  end

  def test_requires_first_call_be_to_select
    assert_no_problems '[1,2,3].map {|x| x > 1 }.size'
  end

  def test_requires_last_call_be_to_select
    assert_no_problems '[1,2,3].select {|x| x > 1 }.sort'
  end

  def test_works_across_statements
    assert_problems 'tmp = [1,2,3].select {|x| x > 1 } ; tmp.select {|x| x >  2}'
  end

  def test_will_not_flag_if_theres_an_intervening_method
    assert_no_problems '[1,2,3].select {|x| x > 1 }.map {|x| x+1 }.select {|x| x > 2}'
  end

  def test_will_not_flag_if_other_method_invoked_on_select_result
    assert_no_problems 'tmp = [1,2,3].select {|x| x > 1 } ; tmp.reject! {|x| x } ; tmp.select {|x| x > 2}'
  end

end
