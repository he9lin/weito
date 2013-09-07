require_relative '../spec_helper'

describe Weito::Client do
  let(:api_key) { "123456" }
  let(:keyword) { "keyword" }
  let(:statuses) { "statuses" }
  let(:statuses_with_keyword) { "statuses with keyword" }

  def stub_faraday_connection(options)
    api_key = options.delete(:api_key)
    keyword = options.delete(:keyword)
    result  = options.delete(:result)
    page    = options.delete(:page)
    count   = options.delete(:count)

    query_path = "/search/topics.json?source=#{api_key}&q=#{keyword}"
    query_path += "&page=#{page}" if page
    query_path += "&count=#{count}" if count

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(query_path) { [ 200, {}, result ] }
    end

    Faraday.new { |builder| builder.adapter :test, stubs }
  end

  describe "#initialize" do
    it 'requires source parameter' do
      expect { described_class.new(double(:conn), nil) }.to \
        raise_error(ArgumentError, /missing api key/)
    end
  end

  describe "#search_topics" do
    it 'passes the source as query param' do
      conn = stub_faraday_connection(
        api_key: api_key, keyword: keyword, result: statuses
      )
      client = described_class.new(conn, api_key)
      result = client.search_topics(keyword)
      expect(result).to eq(statuses)
    end

    it 'requires a "q" query param' do
      conn = stub_faraday_connection(
        api_key: api_key, keyword: keyword, result: statuses
      )
      client = described_class.new(conn, api_key)
      expect { client.search_topics }.to raise_error(ArgumentError)
    end

    it 'passes the keyword as query param' do
      conn = stub_faraday_connection(
        api_key: api_key, keyword: keyword, result: statuses_with_keyword
      )
      client = described_class.new(conn, api_key)
      result = client.search_topics(keyword)
      expect(result).to eq(statuses_with_keyword)
    end

    it 'passes the page as query param' do
      page = 5
      conn = stub_faraday_connection(
        api_key: api_key, keyword: keyword, result: statuses, page: page
      )
      client = described_class.new(conn, api_key)
      result = client.search_topics(keyword, page: page)
      expect(result).to eq(statuses)
    end

    it 'passes the count as query param' do
      count = 10
      conn = stub_faraday_connection(
        api_key: api_key, keyword: keyword, result: statuses, count: count
      )
      client = described_class.new(conn, api_key)
      result = client.search_topics(keyword, count: count)
      expect(result).to eq(statuses)
    end

    it 'raises error if count is greater than 50' do
      count = 51
      conn = stub_faraday_connection(
        api_key: api_key, keyword: keyword, result: statuses, count: count
      )
      client = described_class.new(conn, api_key)
      expect { client.search_topics(keyword, count: count) }.to \
        raise_error(ArgumentError)
    end
  end
end
