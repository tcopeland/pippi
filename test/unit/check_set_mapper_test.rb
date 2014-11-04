require 'test_helper'

class CheckSetMapperTest < Minitest::Test
  def test_should_find_predefined_sets
    csm = Pippi::CheckSetMapper.new('basic')
    assert csm.check_names.include?('SelectFollowedByFirst')
  end

  def test_should_allow_comma_separated_checkset_names
    csm = Pippi::CheckSetMapper.new('a,b')
    csm.predefined_sets = { 'a' => ['foo'], 'b' => ['bar'] }
    assert csm.check_names.include?('foo')
    assert csm.check_names.include?('bar')
  end
end
