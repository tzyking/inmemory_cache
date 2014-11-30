require './cache.rb'

describe Cache do
  describe '#initialize' do
    context 'with LRU eviction strategy' do 
      before do
        @lru_cache = Cache.new(6, :lru)
      end

      it 'creates new cache object' do
        actual_size = @lru_cache.instance_variable_get(:@size)
        actual_data_set = @lru_cache.instance_variable_get(:@data_set)
        expect(actual_size).to eq(6)
        expect(actual_data_set).to eq(Hash.new)
      end
    end

    context 'with random  eviction strategy' do
      before do
        @random_cache = Cache.new(7)
      end
      it 'creates new cache object' do
        actual_size = @random_cache.instance_variable_get(:@size)
        actual_data_set = @random_cache.instance_variable_get(:@data_set)
        expect(actual_size).to eq(7)
        expect(actual_data_set).to eq(Hash.new)
      end
    end
  end

  describe '#add' do 
    context 'with LRU eviction strategy' do
      before do 
        @lru_cache = Cache.new(6, :lru)
        @lru_cache.add('k1', 'v1')
        @lru_cache.add('k2', 'v2')
        @lru_cache.add('k3', 'v3')
        @lru_cache.add('k4', 'v4')
        @lru_cache.add('k5', 'v5')
        @lru_cache.add('k6', 'v6')
        @lru_cache.add('k1', 'updated_v1')
        @lru_cache.add('k7', 'v7')
        @lru_cache.add('k8', 'v8')
        @lru_cache.add('k9', 'v9')
      end

      it 'evicts keys for Least Recently Used items' do 
        expect(@lru_cache.data_set.has_key?('k2')).to be false
        expect(@lru_cache.data_set.has_key?('k3')).to be false
        expect(@lru_cache.data_set.has_key?('k4')).to be false
      end
      
      it 'updates latest value for duplicate keys' do
        expect(@lru_cache.data_set['k1']).to eq('updated_v1')
      end

      it 'store active key value pairs' do 
        expect(@lru_cache.data_set['k5']).to eq('v5')
        expect(@lru_cache.data_set['k6']).to eq('v6')
        expect(@lru_cache.data_set['k7']).to eq('v7')
        expect(@lru_cache.data_set['k8']).to eq('v8')
        expect(@lru_cache.data_set['k9']).to eq('v9')
      end
    end
    
    context 'with random eviction strategy' do
      before do 
        @random_cache = Cache.new(6)
        @random_cache.add('k1', 'v1')
        @random_cache.add('k2', 'v2')
        @random_cache.add('k3', 'v3')
        @random_cache.add('k4', 'v4')
        @random_cache.add('k5', 'v5')
        @random_cache.add('k6', 'v6')
        @random_cache.add('k7', 'v7')
        @random_cache.add('k7', 'updated_v7')
      end

      it 'keeps the size of cache' do
        expect(@random_cache.data_set.size).to eq(6)
      end

      it 'updates latest added key value pairs' do
        expect(@random_cache.data_set['k7']).to eq('updated_v7')
      end
    end
  end
  
  describe '#get' do 
    context 'with LRU eviction strategy' do
      before do 
        @lru_cache = Cache.new(3, :lru)
        @lru_cache.add('k1', 'v1')
        @lru_cache.add('k2', 'v2')
        @lru_cache.add('k3', 'v3')
        @lru_cache.add('k4', 'v4')
      end

      it 'gets value by key' do 
        expect(@lru_cache.get('k2')).to eq('v2')
        expect(@lru_cache.get('k3')).to eq('v3')
        expect(@lru_cache.get('k4')).to eq('v4')
      end

      it 'returns nil for unavailable key' do 
        expect(@lru_cache.get('k1')).to be nil
      end
    end

    context 'with random eviction strategy' do
      before do 
        @random_cache = Cache.new(3)
        @random_cache.add('k1', 'v1')
        @random_cache.add('k2', 'v2')
        @random_cache.add('k3', 'v3')
      end

      it 'gets value by key' do 
        expect(@random_cache.get('k1')).to eq('v1')
        expect(@random_cache.get('k2')).to eq('v2')
        expect(@random_cache.get('k3')).to eq('v3')
      end

      it 'returns nil for unavailable key' do 
        expect(@random_cache.get('k4')).to be nil
        expect(@random_cache.get('k5')).to be nil
      end
    end
  end

  describe '#exists' do 
    context 'with LRU eviction strategy' do
      before do 
        @lru_cache = Cache.new(3, :lru)
        @lru_cache.add('k1', 'v1')
        @lru_cache.add('k2', 'v2')
        @lru_cache.add('k3', 'v3')
        @lru_cache.add('k4', 'v4')
        @lru_cache.add('k5', 'v5')
      end
      
      it 'returns true for exist keys' do
        expect(@lru_cache.exists?('k3')).to be true
        expect(@lru_cache.exists?('k4')).to be true
        expect(@lru_cache.exists?('k5')).to be true
      end

      it 'returns false for unavailable keys' do
        expect(@lru_cache.exists?('k1')).to be false
        expect(@lru_cache.exists?('k2')).to be false
      end      
    end
    
    context 'with random eviction strategy' do
      before do 
        @random_cache = Cache.new(3)
        @random_cache.add('k1', 'v1')
        @random_cache.add('k2', 'v2')
        @random_cache.add('k3', 'v3')
      end

      it 'returns true for exist keys' do
        expect(@random_cache.exists?('k1')).to be true
        expect(@random_cache.exists?('k2')).to be true
        expect(@random_cache.exists?('k3')).to be true
      end
      
      it 'returns false for unavailable keys' do
        expect(@random_cache.exists?('k4')).to be false
        expect(@random_cache.exists?('k5')).to be false
      end
    end

  end
end