class Foo
  def bar
    x = [1,2,3]
    x.map {|y| [y, y+1] }.flatten
  end
end
