class TracepointListener

  attr_reader :rules

  def initialize(rules)
    @rules = [rules].flatten
    TracePoint.trace do |tracepoint|
      self.send(event_callback_method_name_for_tracepoint(tracepoint), tracepoint)
    end
  end

  def event_callback_method_name_for_tracepoint(tracepoint)
    "#{tracepoint.event}_event"
  end

  # From vm_trace.c:
  # static const char *
  # get_event_name(rb_event_flag_t event)
  # {
  #     switch (event) {
  #       case RUBY_EVENT_LINE:     return "line";
  #       case RUBY_EVENT_CLASS:    return "class";
  #       case RUBY_EVENT_END:      return "end";
  #       case RUBY_EVENT_CALL:     return "call";
  #       case RUBY_EVENT_RETURN: return "return";
  #       case RUBY_EVENT_C_CALL: return "c-call";
  #       case RUBY_EVENT_C_RETURN: return "c-return";
  #       case RUBY_EVENT_RAISE:  return "raise";
  #       default:
  #   return "unknown";
  #     }
  # }
  def method_missing(method_name, *args, &blk)
    rules.each do |rule|
      if rule.respond_to?(method_name)
        rule.send(method_name, args[0])
      end
    end
  end

end
