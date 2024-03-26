# Collection Module

The `Collection` module provides utility functions for working with arrays.

## Usage

### Collect Class

The `Collect` class is used to create chainable collections for easy manipulation of arrays.

#### Before

```ruby
items = [
  { a: 3, b: 1, x: [1, 2, 3] },
  { a: 1, b: 2, x: [] },
  { a: 2, b: 3, x: [2, 3] },
  nil
]

# Remove nil items
items.compact!

# Filter items where :a is greater than 1
items.select! { |item| item[:a] > 1 }

# Append { a: 0, b: 2 } if specified
items << { a: 0, b: 2 } if params[:should_append]

# Prepend { a: 4, b: 2 }
items.unshift({ a: 4, b: 2 })

# Sort items by :a
items.sort_by! { |item| item[:a] }

# Map items to new structure
items.map! do |item|
  {
    a: item[:a],
    b: item[:b],
    c: item[:a] + item[:b],
    x: item[:x].sort
  }
end
```

#### After

```ruby
collect(items)
  .where_not_nil
  .where(:a, ">", 1)
  .when(params[:should_append]) do |collections|
    collections.append({ a: 0, b: 2 })
  end
  .prepend({ a: 4, b: 2 })
  .sort_by_key(:a)
  .map do |item|
    {
      a: item[:a],
      b: item[:b],
      c: item[:a] + item[:b],
      x: collect(item[:x]).sort.all
    }
  end
  .all
```

#### Example:

##### Filter

```ruby
include ArrayCollection::Helper # Include collection helper to call collect only instead of ArrayCollection::collect.new

# Create a new collection
collect([1, 2, 3, 4, 5]).filter { |item| item > 2 }.all
# => [3, 4, 5]
```

##### Where

```ruby
include ArrayCollection::Helper

# Create a new collection
collect([
  { name: 'Alice', age: 30 },
  { name: 'Bob', age: 25 }
]).where(:age, '>', 25)
  .all
# => [{ name: 'Alice', age: 30 }]
```

##### Where not nil

```ruby
result = collect([1, 2, nil, 3, 4, nil, 5])
               .where_not_nil
               .all
# => [1, 2, 3, 4, 5]
```

##### index_of

```ruby
collect([1, 2, 3, 4, 2]).index_of(2)
# => 1
```
