### basic

#### ReverseFollowedByEach

Don't use each followed by reverse; use reverse_each instead

For example, rather than doing this:

```ruby
[1,2,3].reverse.each {|x| x+1 }
```

Instead, consider doing this:

```ruby
[1,2,3].reverse_each {|x| x+1 }
```

#### SelectFollowedByEmpty

Don't use select followed by empty?; use none? instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.empty?
```

Instead, consider doing this:

```ruby
[1,2,3].none? {|x| x > 1 }
```

#### SelectFollowedByFirst

Don't use select followed by first; use detect instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.first
```

Instead, consider doing this:

```ruby
[1,2,3].detect {|x| x > 1 }
```

#### SelectFollowedBySize

Don't use select followed by size; use count instead

For example, rather than doing this:

```ruby
[1,2,3].select {|x| x > 1 }.size
```

Instead, consider doing this:

```ruby
[1,2,3].count {|x| x > 1 }
```
### buggy

#### AssertWithNil

Don't use assert_equal with nil as a first argument; use assert_nil instead

For example, rather than doing this:

```ruby
x = nil ; assert_equal(nil, x)
```

Instead, consider doing this:

```ruby
x = nil ; assert_nil(x)
```

#### MapFollowedByFlatten

Don't use map followed by flatten; use flat_map instead

For example, rather than doing this:

```ruby
[1,2,3].map {|x| [x,x+1] }.flatten
```

Instead, consider doing this:

```ruby
[1,2,3].flat_map {|x| [x, x+1]}
```
