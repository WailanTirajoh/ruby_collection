# Collection Module

The `Collection` module provides utility functions for working with arrays.

## Usage

### Collect Class

The `Collect` class is used to create chainable collections for easy manipulation of arrays.

#### Example:

```ruby
# Create a new collection
collection = Collection::Collect.new([1, 2, 3, 4, 5])

# Filter elements greater than 2
result = collection.where { |item| item > 2 }.all
# => [3, 4, 5]

# Filter out nil values
result = collection.where_not_nil.all
# => [1, 2, 3, 4, 5]

# Get the index of value 3
index = collection.index_of(3)
# => 2

# Group records by 'badgenumber' and transform attributes
result = collection.key_by('hash_key') do |record|
  {
    'my_first_key' => record['my_first_key'],
    'my_second_key' => record['my_second_key']
  }
end
# => { '1' => { 'my_first_key' => ..., 'my_second_key' => ... }, ... }
