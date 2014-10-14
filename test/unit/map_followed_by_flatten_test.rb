require 'test_helper'

class MapFollowedByFlattenTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "[1,2,3].map {|x| [x,x+1] }.flatten(1)"
  end

  def test_requires_first_call_be_to_map
    assert_no_problems "[1,2,3].select {|x| [x,x+1] }.flatten(1)"
  end

  def test_requires_last_call_be_to_flatten
    assert_no_problems "[1,2,3].map {|x| [x] }.first"
  end

  def test_works_across_statements
    assert_problems "tmp = [1,2,3].map {|x| [x] } ; tmp.flatten(1)"
  end

  def test_requires_arg_to_flatten_to_be_one
    assert_no_problems "[1,2,3].map {|x| [x] }.flatten"
  end

  def test_will_not_flag_if_theres_an_intervening_method
    assert_no_problems "[1,2,3].map {|x| [x] }.select {|x| x.to_s > '1' }.flatten(1)"
  end

  def test_will_not_flag_if_mutator_invoked
    assert_no_problems "t = [1,2,3].map {|x| [x] } ; t.select! {|x| rand > 0.5 } ; t.flatten(1)"
  end

=begin
  def test_dfa_issue
    assert_no_problems "t = [1,2,3].map {|x| [x] } ; if (rand > 0.5) ; t.sort! ; end ; t.flatten(1)"
  end
=end
end
