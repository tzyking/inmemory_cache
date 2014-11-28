require './list_node.rb'

module Evictable 
  def set_up_list(eviction_strategy)
    @eviction_strategy = eviction_strategy

    if @eviction_strategy == :lru
      @data_map = Hash.new
      @head = ListNode.new
      @tail = ListNode.new
      @head.next_node = @tail
      @tail.pre_node = @head
    end
  end

  def eviction(keys = nil) 
    if @eviction_strategy == :lru
      evictable_node = @tail.pre_node
      remove(evictable_node)
      @data_map.delete(evictable_node.key)
      return evictable_node.key
    end
    
    keys.sample if @eviction_strategy == :random
  end

  def push_list(key, value)
    if @eviction_strategy == :lru
      if @data_map.has_key?(key)
        node = @data_map[key]
        node.value = value
        remove(node)
        prepend(node)
      else
        new_node = ListNode.new(key, value)
        @data_map[key] = new_node
        prepend(new_node)
      end
    end
  end

  def update_list(key)
    if @eviction_strategy == :lru && @data_map.has_key?(key)
      node = @data_map[key]
      remove(node)
      prepend(node)
    end
  end
  
  private 
  
    def remove(node)
      node.pre_node.next_node = node.next_node
      node.next_node.pre_node = node.pre_node
    end

    def prepend(node)
      node.pre_node = @head
      node.next_node = @head.next_node
      @head.next_node.pre_node = node
      @head.next_node = node
    end
end