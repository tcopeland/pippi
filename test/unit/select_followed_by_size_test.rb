require 'test_helper'

class SelectFollowedBySizeTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "[1,2,3].select {|x| x > 2 }.size"
  end

  def test_two_line_case_is_found
    assert_problems "x = [1,2,3].select {|x| x > 2 } ; x.size"
  end

  def test_check_does_not_fire_if_no_size_call
    assert_no_problems "[1,2,3].select {|x| x > 2 }"
  end

  def test_check_does_not_fire_if_size_called_on_other_object
    assert_no_problems "y = [1,2,3].select {|x| x > 2 } ; z = [1,2] ; z.size"
  end

  def test_intervening_method_call_prevents_report
    assert_no_problems "y = [1,2,3].select {|x| x > 2 } ; y.map {|z| z+1} ; y.size"
  end

  # This causes us to miss some cases, but prevents some false positive
  def test_must_be_on_same_line
    example = <<-EOS
if 2>1
  y = [1,2,3].select {|x| x > 2 }
  return if y.size == 2
else
  y = []
end
puts y
EOS
    assert_no_problems example
  end

  protected

  def check_for_test
    "SelectFollowedBySize"
  end

end
