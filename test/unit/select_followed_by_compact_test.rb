require "test_helper"
require 'fileutils'

class SelectFollowedByCompactTest < MiniTest::Test

  def test_canonical_case_is_found
    assert_equal 1, execute_pippi_on(foo_bar_code_sample("[1,2,nil].select {|x| x }.compact")).size
  end

  protected

  def rule_for_test
    "SelectFollowedByCompact"
  end
end
