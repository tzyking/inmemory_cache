require './evictable.rb'

class Cache
  include Evictable
  attr_reader :size, :data_set

  def initialize(size, eviction_strategy = :random)
    @size = size 
    @data_set = Hash.new
    set_up_list(eviction_strategy)
  end

  def add(key, value)
    if @data_set.length == @size && !@data_set.has_key?(key)
      evictable_key = eviction
      @data_set.delete(evictable_key)
    end

    push_list(key, value)
    @data_set[key] = value
  end

  def get(key)
    update_list(key)
    @data_set[key]
  end

  def exists?(key)
    @data_set.has_key?(key)
  end
end