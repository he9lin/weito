require_relative 'spec_helper'

describe Weito do
  let(:api_key) { '123456789' }
  let(:keyword) { 'keyword' }

  before do
    described_class.api_key = nil
  end

  it 'has accessor for api_key' do
    described_class.api_key = api_key
    expect(described_class.api_key).to eq(api_key)
  end

  describe 'Searching topics with params with #search' do
    it 'should raise error if API key not set yet' do
      expect { described_class.search(keyword) }.to \
        raise_error('API key not set')
    end

    it 'uses the correct API endpoint' do
      described_class.api_key = api_key
      stub_request :get,
        "https://api.weibo.com/search/topics.json?q=#{keyword}&source=#{described_class.api_key}"
      described_class.search(keyword)
    end
  end
end
