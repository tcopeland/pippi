class SomeCheck
  def create_check_proc
    Proc.new do
      def self.first
        res2 = super
        puts caller.inspect
        puts "BOOM problem"
        res2
      end
    end
  end
end

def decorate_select_method(array)
  def array.select(&blk)
    result = super
    result.instance_eval &SomeCheck.new.create_check_proc
    result
  end
end

x = [1,2,3]
decorate_select_method(x)
puts x.select {|y| y > 2}.first

