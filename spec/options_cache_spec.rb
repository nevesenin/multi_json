require "spec_helper"

describe MultiJson::OptionsCache do
  describe 'dump something' do
    it 'does not raise a error' do
      described_class.instance_variable_set(:@dump_cache, nil)
      described_class.instance_variable_set(:@load_cache, nil)

      expect do
        MultiJson.dump({ foo: 'bar' }, mode: :rails, adapter: :oj)
      end.not_to raise_error
    end
  end

  it "doesn't leak memory" do
    described_class.reset

    described_class::MAX_CACHE_SIZE.succ.times do |i|
      described_class.fetch(:dump, :key => i) do
        { :foo => i }
      end

      described_class.fetch(:load, :key => i) do
        { :foo => i }
      end
    end

    expect(described_class.instance_variable_get(:@dump_cache).length).to eq(1)
    expect(described_class.instance_variable_get(:@load_cache).length).to eq(1)
  end
end
