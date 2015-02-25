module Pippi::Checks

  # TODO make this use MethodSequenceChecker
  class MapFollowedByFlatten < Check
    module MyFlatten
      def flatten(depth = nil)
        if depth && depth == 1
          self.class._pippi_check_map_followed_by_flatten.add_problem
        end
        if depth
          super(depth)
        else
          super()
        end
      end
    end

    module MyMap
      def map(&blk)
        result = super
        if self.class._pippi_check_map_followed_by_flatten.nil?
          # Ignore Array subclasses since map or flatten may have difference meanings
        else
          result.extend MyFlatten
          self.class._pippi_check_map_followed_by_flatten.mutator_methods.each do |this_means_its_ok_sym|
            result.define_singleton_method(this_means_its_ok_sym, self.class._pippi_check_map_followed_by_flatten.its_ok_watcher_proc(MyFlatten, :flatten))
          end
        end
        result
      end
    end

    def decorate
      Array.class_exec(self) do |my_check|
        # How to do this without a class instance variable?
        @_pippi_check_map_followed_by_flatten = my_check
        class << self
          attr_reader :_pippi_check_map_followed_by_flatten
        end
        prepend MyMap
      end
    end

    class Documentation
      def description
        "Don't use map followed by flatten(1); use flat_map instead"
      end

      def sample
        '[1,2,3].map {|x| [x,x+1] }.flatten(1)'
      end

      def instead_use
        '[1,2,3].flat_map {|x| [x, x+1]}'
      end
    end
  end
end
