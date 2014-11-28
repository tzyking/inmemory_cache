class ListNode 
  attr_accessor :key, :value, :pre_node, :next_node

  def initialize(key = nil, value = nil, pre_node = nil, next_node = nil) 
    self.key = key 
    self.value = value 
    self.pre_node = pre_node
    self.next_node = next_node 
  end
end