require "test_helper"

class StripFollowedByEmptyTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "'   '.strip.empty?"
  end

  def test_requires_first_call_be_to_strip
    assert_no_problems "'   '.downcase.empty?"
  end

  def test_requires_last_call_be_to_empty
    assert_no_problems "'   '.strip.size"
  end

  def test_works_across_statements
    assert_problems "tmp = '   '.strip ; tmp.empty?"
  end

  def test_will_not_flag_if_theres_an_intervening_method
    assert_no_problems "'   '.strip.downcase.empty?"
  end

  def test_will_not_flag_if_other_method_invoked_on_strip_resultzz
    assert_no_problems "tmp = '   '.strip ; tmp.insert(0, 'foo') ; tmp.empty?"
  end

end
