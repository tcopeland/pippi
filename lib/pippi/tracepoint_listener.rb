class TracepointListener

  attr_reader :checks

  def initialize(checks)
    @checks = [checks].flatten
    TracePoint.trace do |tracepoint|
      self.send(event_callback_method_name_for_tracepoint(tracepoint), tracepoint)
    end
  end

  def event_callback_method_name_for_tracepoint(tracepoint)
    "#{tracepoint.event}_event"
  end

  # From vm_trace.c:
  # C(line, LINE);
  # C(class, CLASS);
  # C(end, END);
  # C(call, CALL);
  # C(return, RETURN);
  # C(c_call, C_CALL);
  # C(c_return, C_RETURN);
  # C(raise, RAISE);
  # C(b_call, B_CALL);
  # C(b_return, B_RETURN);
  # C(thread_begin, THREAD_BEGIN);
  # C(thread_end, THREAD_END);
  # C(specified_line, SPECIFIED_LINE);
  #       case RUBY_EVENT_LINE | RUBY_EVENT_SPECIFIED_LINE: CONST_ID(id, "line"); return id;
  def method_missing(method_name, *args, &blk)
    checks.each do |check|
      if check.respond_to?(method_name)
        check.send(method_name, args[0])
      end
    end
  end

end
