module Pippi::Checks

  class MapFollowedByFlatten < Check

    module MyFlatten
      def flatten(depth=nil)
        result = super(depth)
        if depth && depth == 1
          problem_location = caller_locations.detect {|c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
          self.class._pippi_check_map_followed_by_flatten.add_problem(problem_location.lineno, problem_location.path)
        end
        result
      end
    end

    module MyMap
      def map(&blk)
        result = super
        if self.class._pippi_check_map_followed_by_flatten.nil?
          # Ignore Array subclasses since map or flatten may have difference meanings
        else
          result.extend MyFlatten
          self.class._pippi_check_map_followed_by_flatten.array_mutator_methods.each do |this_means_its_ok_sym|
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
        def self._pippi_check_map_followed_by_flatten
          @_pippi_check_map_followed_by_flatten
        end
      end
      Array.prepend MyMap
    end

    class Documentation
      def description
        "Don't use map followed by flatten; use flat_map instead"
      end
      def sample
        "[1,2,3].map {|x| [x,x+1] }.flatten"
      end
      def instead_use
        "[1,2,3].flat_map {|x| [x, x+1]}"
      end
    end

  end

end
