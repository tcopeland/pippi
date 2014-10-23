require "test_helper"

class AssertWithNilTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "x = 42 ; assert_equal(nil, x)", :include_rails_core_extensions => true, :subclass => "ActiveSupport::TestCase"
  end

  def test_non_nil_first_arg_doesnt_flag
    assert_no_problems "x = 42 ; assert_equal(42, x)", :include_rails_core_extensions => true, :subclass => "ActiveSupport::TestCase"
  end

  # Seems like there's some way to do this, but maybe not... anyhow, moving this rule to "buggy" for now
  # pippi> $ echo "foo(nil)" | ruby --dump insns
  # == disasm: <RubyVM::InstructionSequence:<main>@->=======================
  # 0000 trace            1                                               (   1)
  # 0002 putself
  # 0003 putnil
  # 0004 opt_send_simple  <callinfo!mid:foo, argc:1, FCALL|ARGS_SKIP>
  # 0006 leave
  # pippi> $ echo "foo(x)" | ruby --dump insns
  # == disasm: <RubyVM::InstructionSequence:<main>@->=======================
  # 0000 trace            1                                               (   1)
  # 0002 putself
  # 0003 putself
  # 0004 opt_send_simple  <callinfo!mid:x, argc:0, FCALL|VCALL|ARGS_SKIP>
  # 0006 opt_send_simple  <callinfo!mid:foo, argc:1, FCALL|ARGS_SKIP>
  # 0008 leave
  # also consider
=begin
class Bar
  def buz(x)
  end
  def foo
    y = nil
    buz(y)
    RubyVM::InstructionSequence.of(method(__method__)).disasm.split("\n").each {|x| puts x }
  end
end
Bar.new.foo
=end
  def test_nil_reference_first_arg_doesnt_flag
    assert_no_problems "x = 42 ; y = nil ; assert_equal(nil, x)", :include_rails_core_extensions => true, :subclass => "ActiveSupport::TestCase"
  end

  def test_three_arg_is_flagged
    assert_problems "x = 42 ; assert_equal(nil, x, 'whatevs')", :include_rails_core_extensions => true, :subclass => "ActiveSupport::TestCase"
  end

end
