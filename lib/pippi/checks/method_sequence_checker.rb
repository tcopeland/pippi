class MethodSequenceChecker

  ARITY_TYPE_BLOCK_ARG = 1
  ARITY_TYPE_NONE = 2

  attr_reader :check, :clazz_to_decorate, :method1, :method2, :first_method_arity_type, :second_method_arity_type, :should_check_subsequent_calls

  def initialize(check, clazz_to_decorate, method1, method2, first_method_arity_type, second_method_arity_type, should_check_subsequent_calls)
    @check = check
    @clazz_to_decorate = clazz_to_decorate
    @method1 = method1
    @method2 = method2
    @first_method_arity_type = first_method_arity_type
    @second_method_arity_type = second_method_arity_type
    @should_check_subsequent_calls = should_check_subsequent_calls
  end

  def decorate
    clazz_to_decorate.class_exec(check, self) do |my_check, method_sequence_check_instance|
      name = "@_pippi_check_#{my_check.class.name.split('::').last.downcase}"
      self.instance_variable_set(name, my_check)
      self.class.send(:define_method, name[1..-1]) do
        instance_variable_get(name)
      end

      # e.g., "size" in "select followed by size"
      second_method_decorator = Module.new do
        define_method(method_sequence_check_instance.method2) do |*args, &blk|
          self.class.instance_variable_get(name).add_problem
          if method_sequence_check_instance.should_check_subsequent_calls && method_sequence_check_instance.clazz_to_decorate == Array
            problem_location = caller_locations.find { |c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
            self.class.instance_variable_get(name).method_names_that_indicate_this_is_being_used_as_a_collection.each do |this_means_its_ok_sym|
              define_singleton_method(this_means_its_ok_sym, self.class.instance_variable_get(name).clear_fault_proc(self.class.instance_variable_get(name), problem_location))
            end
          end
          if method_sequence_check_instance.second_method_arity_type == ARITY_TYPE_BLOCK_ARG
            super(&blk)
          elsif method_sequence_check_instance.second_method_arity_type == ARITY_TYPE_NONE
            super()
          end
        end
      end

      # e.g., "select" in "select followed ARITY_TYPE_NONEze"
     first_method_decorator = Module.new do
        define_method(method_sequence_check_instance.method1) do |*args, &blk|
          result = if method_sequence_check_instance.first_method_arity_type == ARITY_TYPE_BLOCK_ARG
            super(&blk)
          elsif method_sequence_check_instance.first_method_arity_type == ARITY_TYPE_NONE
            super()
          end
          if self.class.instance_variable_get(name)
            result.extend second_method_decorator
            self.class.instance_variable_get(name).array_mutator_methods.each do |this_means_its_ok_sym|
              result.define_singleton_method(this_means_its_ok_sym, self.class.instance_variable_get(name).its_ok_watcher_proc(second_method_decorator, method_sequence_check_instance.method2))
            end
          end
          result
        end
      end
      prepend first_method_decorator
    end
  end

  def array_mutator_methods
    [:collect!, :compact!, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!]
  end

  def its_ok_watcher_proc(clazz, method_name)
    proc do |*args, &blk|
      begin
        singleton_class.ancestors.find { |x| x == clazz }.instance_eval { remove_method method_name }
      rescue NameError
        return super(*args, &blk)
      else
        return super(*args, &blk)
      end
    end
  end
end
