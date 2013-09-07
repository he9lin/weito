# TODO: json result in which format?
#
module Weito
  class Client
    MAX_SEARCH_RESULT_COUNT = 50

    def initialize(conn, source)
      raise ArgumentError, 'missing api key' unless source

      @conn = conn
      @source = source
    end

    def search_topics(keyword, opts={})
      raise ArgumentError, 'missing keyword to search' unless keyword
      req_opts = build_search_opts({source: @source, q: keyword}, opts)

      response = @conn.get "/search/topics.json",  req_opts do |req|
        req.headers['Accept'] = 'application/json'
      end

      response.body
    end

    private

    def build_search_opts(base_opts, additional_opts)
      page  = additional_opts.delete(:page)
      count = additional_opts.delete(:count)

      raise ArgumentError, 'count must not be greater than 50' \
        if count && count > MAX_SEARCH_RESULT_COUNT

      base_opts[:page]  = page  if page
      base_opts[:count] = count if count
      base_opts
    end
  end
end
