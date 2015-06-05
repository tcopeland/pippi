class CheckDescriptor

  attr_accessor :check, :clazz_to_decorate, :method_sequence, :should_check_subsequent_calls

  def initialize(check_object)
    @check = check_object
    @should_check_subsequent_calls = true
  end

end