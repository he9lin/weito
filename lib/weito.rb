require 'faraday'
require 'faraday_middleware'
require 'json'

require_relative 'weito/client'

module Weito
  def self.api_key
    @api_key || raise('API key not set')
  end

  def self.api_key=(key)
    @api_key = key
  end

  def self.search(keyword)
    client.search_topics(keyword)
  end

  def self.client
    conn = Faraday.new(url: 'https://api.weibo.com/2') do |faraday|
      faraday.request  :url_encoded
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    Client.new(conn, api_key)
  end
end
