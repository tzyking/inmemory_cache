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

# a = Cache.new(6)
# a.add(:k1, 'v1')
# a.add(:k2, 'v2')
# a.add(:k3, 'v3')
# a.add(:k4, 'v4')
# a.add(:k5, 'v5')
# a.add(:k6, 'v6')
# a.add(:k6, 'v61')
# p a.get(:k4)
# a.add(:k7, 'v7')
# a.add(:k8, 'v8')
# a.add(:k9, 'v9')
# a.add(:k10, 'v10')
# a.add(:k11, 'v11')
# a.add(:k12, 'v12')
# p a.data_set.size

# p a.exists(:k1)
# p a.exists(:k2)
# p a.exists(:k3)
# p a.exists(:k4)
# p a.exists(:k5)
# p a.exists(:k6)
# p a.exists(:k7)
# p a.exists(:k8)
# p a.exists(:k9)
# p a.exists(:k10)
# p a.exists(:k11)
# p a.exists(:k12)

# a = Cache.new(6, :lru)
# a.add(:k1, 'v1')
# a.add(:k2, 'v2')
# a.add(:k3, 'v3')
# a.add(:k4, 'v4')
# a.add(:k5, 'v5')
# a.add(:k6, 'v6')
# a.add(:k6, 'v61')
# p a.get(:k4)
# a.add(:k7, 'v7')
# a.add(:k8, 'v8')
# a.add(:k9, 'v9')
# a.add(:k10, 'v10')
# a.add(:k11, 'v11')
# a.add(:k12, 'v12')

# p a.exists(:k1)
# p a.exists(:k2)
# p a.exists(:k3)
# p a.exists(:k4)
# p a.exists(:k5)
# p a.exists(:k6)
# p a.exists(:k7)
# p a.exists(:k8)
# p a.exists(:k9)
# p a.exists(:k10)
# p a.exists(:k11)
# p a.exists(:k12)
