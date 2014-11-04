module Pippi::Checks
  class DebugCheck < Check
    %w(line class end call return c_call c_return b_call b_return raise thread_begin thread_end).each do |event_name|
      define_method "#{event_name}_event" do |tp|
        return if tp.path =~ %r{lib/pippi}
        ctx.debug_logger.warn "#{event_name}_event in #{tp.defined_class}##{tp.method_id} at line #{tp.lineno} of #{tp.path}"
        ctx.debug_logger.warn "  return_value #{tp.return_value}" rescue nil
      end
    end
  end
end
