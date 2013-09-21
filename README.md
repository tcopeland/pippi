Pippi is a Ruby runtime code analysis tool

Examples of problems to detect:

# unnecessary assignment since String#strip! mutates receiver 
# wrong
x = x.strip!
# right
x.strip!

# use Enumerable#detect instead
# wrong
[1,2,3].select {|x| x > 1 }.first
# right
[1,2,3].detect {|x| x > 1 }

# Use Pathname
# wrong
File.read(File.join(Rails.root, "config", "database.yml")
# right
Rails.root.join("config", "database.yml").read

# Use Kernel#tap
# wrong
x = [1,2]
x << 3
return x
# right
[1,2].tap {|y| y << 3 }
