require './evictable.rb'
require './list_node.rb'

describe Evictable do
  class DummyClass
  end

  before(:all) do
    @dummy = DummyClass.new
    @dummy.extend Evictable
  end

  let(:expected_head) { ListNode.new }  
  let(:expected_tail) { ListNode.new }  
  let(:item1) { ListNode.new('k1', 'v1') }
  let(:item2) { ListNode.new('k2', 'v2') }
  
  describe '#set_up_list' do  
    it 'set up instance variable eviction_strategy with random eviction strategy' do
      @dummy.set_up_list(:random)
      actual_key_set = @dummy.instance_variable_get(:@key_set)
      expect(@dummy.instance_variable_get(:@eviction_strategy)).to eq(:random)
      expect(actual_key_set).to eq(Array.new)
    end

    it 'set up instance variables with lru eviction strategy' do
      @dummy.set_up_list(:lru)
      actual_head = @dummy.instance_variable_get(:@head)
      actual_tail = @dummy.instance_variable_get(:@tail)

      expect(@dummy.instance_variable_get(:@data_map)).to eq({})
      expect(actual_head.next_node).to eq(actual_tail)
      expect(actual_tail.pre_node).to eq(actual_head)
    end
  end

  describe '#push_list' do 
    it 'creates new node and push to the list with lru eviction strategy' do 
      @dummy.set_up_list(:lru)
      @dummy.push_list('k1', 'v1')
      @dummy.push_list('k2', 'v2')
      @dummy.push_list('k3', 'v3')

      actual_data_map = @dummy.instance_variable_get(:@data_map)
      actual_head = @dummy.instance_variable_get(:@head)
      actual_tail = @dummy.instance_variable_get(:@tail)
      actual_item1 = actual_data_map['k1']
      actual_item2 = actual_data_map['k2']
      actual_item3 = actual_data_map['k3']

      expect(actual_head.next_node).to eq(actual_item3)

      expect(actual_item3.pre_node).to eq(actual_head)
      expect(actual_item3.key).to eq('k3')
      expect(actual_item3.value).to eq('v3')
      expect(actual_item3.next_node).to eq(actual_item2)

      expect(actual_item2.pre_node).to eq(actual_item3)
      expect(actual_item2.key).to eq('k2')
      expect(actual_item2.value).to eq('v2')
      expect(actual_item2.next_node).to eq(actual_item1)

      expect(actual_item1.pre_node).to eq(actual_item2)
      expect(actual_item1.key).to eq('k1')
      expect(actual_item1.value).to eq('v1')
      expect(actual_item1.next_node).to eq(actual_tail)

      expect(actual_tail.pre_node).to eq(actual_item1)
    end 

    it 'updates node value and prepends to the list head with lru eviction strategy' do       
      @dummy.set_up_list(:lru)
      @dummy.push_list('k1', 'v1')
      @dummy.push_list('k2', 'v2')
      @dummy.push_list('k1', 'updated_v1')
      
      actual_data_map = @dummy.instance_variable_get(:@data_map)
      actual_head = @dummy.instance_variable_get(:@head)
      actual_tail = @dummy.instance_variable_get(:@tail)
      actual_item1 = actual_data_map['k1']
      actual_item2 = actual_data_map['k2']

      expect(actual_head.next_node).to eq(actual_item1)

      expect(actual_item1.pre_node).to eq(actual_head)
      expect(actual_item1.key).to eq('k1')
      expect(actual_item1.value).to eq('updated_v1')
      expect(actual_item1.next_node).to eq(actual_item2)

      expect(actual_item2.pre_node).to eq(actual_item1)
      expect(actual_item2.key).to eq('k2')
      expect(actual_item2.value).to eq('v2')
      expect(actual_item2.next_node).to eq(actual_tail)
      
      expect(actual_tail.pre_node).to eq(actual_item2)
    end

    it 'pushs key to key_set with random eviction strategy' do 
      @dummy.set_up_list(:random)
      @dummy.push_list('k1', 'v1')
      @dummy.push_list('k2', 'v2')
      @dummy.push_list('k3', 'v3')
      @dummy.push_list('k3', 'updated_v3')

      actual_key_set = @dummy.instance_variable_get(:@key_set)
      expeced_key_set = ['k1', 'k2', 'k3']
      
      expect(actual_key_set).to eq(expeced_key_set)
    end
  end

  describe '#eviction' do 
    let(:original_key_set) { ['k1', 'k2', 'k3', 'k4', 'k5'] }

    it 'evicts last node of list with lru eviction strategy' do 
      @dummy.set_up_list(:lru)
      @dummy.push_list('k1', 'v1')
      @dummy.push_list('k2', 'v2')
      evicted_key = @dummy.eviction()

      actual_head = @dummy.instance_variable_get(:@head)
      actual_tail = @dummy.instance_variable_get(:@tail)
      actual_data_map = @dummy.instance_variable_get(:@data_map)
      actual_data_map = @dummy.instance_variable_get(:@data_map)
      actual_item2 = actual_data_map['k2']
        
      expect(evicted_key).to eq('k1') 
      expect(actual_data_map['k1']).to be_nil
      expect(actual_head.next_node).to eq(actual_item2)
      
      expect(actual_item2.pre_node).to eq(actual_head)
      expect(actual_item2.key).to eq('k2')
      expect(actual_item2.next_node).to eq(actual_tail)

      expect(actual_tail.pre_node).to eq(actual_item2)
    end

    it 'returns randome key from input key list with random eviction strategy' do
      @dummy.set_up_list(:random)
      @dummy.push_list('k1', 'v1')
      @dummy.push_list('k2', 'v2')
      @dummy.push_list('k3', 'v3')
      @dummy.push_list('k4', 'v4')
      @dummy.push_list('k5', 'v5')
      actual_evictable_key = @dummy.eviction
      actual_key_set = @dummy.instance_variable_get(:@key_set)

      expect(original_key_set).to include(actual_evictable_key)
      expect(original_key_set).to include(*actual_key_set)
    end
  end

  describe '#update_list' do 
    it 'updates position of node in list with lru eviction strategy' do 
      @dummy.set_up_list(:lru)
      @dummy.push_list('k1', 'v1')
      @dummy.push_list('k2', 'v2')
      @dummy.update_list('k1')
      actual_head = @dummy.instance_variable_get(:@head)
      acutal_tail = @dummy.instance_variable_get(:@tail)
      actual_item1 = actual_head.next_node
      actual_item2 = acutal_tail.pre_node

      expect(actual_item1.key).to eq('k1')
      expect(actual_item1.value).to eq('v1')
      expect(actual_item1.pre_node).to eq(actual_head)
      expect(actual_item1.next_node).to eq(actual_item2)
      expect(actual_item2.key).to eq('k2')
      expect(actual_item2.value).to eq('v2')
      expect(actual_item2.pre_node).to eq(actual_item1)
      expect(actual_item2.next_node).to eq(acutal_tail)
    end 
  end
end