require "test_helper"

class AssertWithNilTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "x = 42 ; assert_equal(nil, x)", :include_rails_core_extensions => true, :subclass => "ActiveSupport::TestCase"
  end

  def test_non_nil_first_arg_doesnt_flag
    assert_no_problems "x = 42 ; assert_equal(42, x)", :include_rails_core_extensions => true, :subclass => "ActiveSupport::TestCase"
  end

  def test_three_arg_is_flagged
    assert_problems "x = 42 ; assert_equal(nil, x, 'whatevs')", :include_rails_core_extensions => true, :subclass => "ActiveSupport::TestCase"
  end

end
