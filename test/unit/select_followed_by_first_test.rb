require 'test_helper'
require 'fileutils'

class SelectFollowedByFirstTest < MiniTest::Test

  def test_canonical_case_is_found
    assert_equal 1, execute_pippi_on(foo_bar_code_sample("[1,2,3].select {|x| x > 2 }.first")).size
  end

  def test_two_line_case_is_found
    assert_equal 1, execute_pippi_on(foo_bar_code_sample("x = [1,2,3].select {|x| x > 2 } ; x.first")).size
  end

  def test_rule_does_not_fire_if_no_first_call
    assert execute_pippi_on(foo_bar_code_sample("[1,2,3].select {|x| x > 2 }")).empty?
  end

  protected

  def rule_for_test
    "SelectFollowedByFirst"
  end

end
