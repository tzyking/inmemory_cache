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
    elsif @eviction_strategy == :random
      @key_set = Array.new
    end
  end

  def eviction 
    if @eviction_strategy == :lru
      evictable_node = @tail.pre_node
      remove(evictable_node)
      @data_map.delete(evictable_node.key)
      evictable_node.key
    elsif @eviction_strategy == :random
      evictable_key = @key_set.sample
      @key_set.delete(evictable_key)
    end
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
    elsif @eviction_strategy == :random && !@key_set.include?(key)
      @key_set << key
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
