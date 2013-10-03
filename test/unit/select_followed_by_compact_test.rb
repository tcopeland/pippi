require "test_helper"
require 'fileutils'

class SelectFollowedByCompactTest < CheckTest

  def test_canonical_case_is_found
    assert_equal 1, execute_pippi_on(foo_bar_code_sample("[1,2,nil].select {|x| x }.compact")).size
  end

  def test_no_error_if_no_compact_call
    assert_no_problems "[1,2,nil].select {|x| x }"
  end

  def test_duplicate_hits_are_not_recorded
    assert_equal 1, execute_pippi_on(foo_bar_code_sample("10.times { [1,2,nil].select {|x| x }.compact }")).size
  end

  def test_check_does_not_fire_if_compact_called_on_other_object
    assert_no_problems "y = [1,2,3].select {|x| x > 2 } ; z = [1,2] ; z.compact"
  end


  protected

  def check_for_test
    "SelectFollowedByCompact"
  end
end
