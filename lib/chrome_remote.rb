require "chrome_remote/version"
require "chrome_remote/client"
require "json"
require "net/http"

module ChromeRemote
  class << self
    DEFAULT_OPTIONS = {
      host: "127.0.0.1",
      port: 9222
    }

    def client(options = {})
      options = DEFAULT_OPTIONS.merge(options)

      Client.new(get_ws_url(options))
    end

    private

    def get_ws_url(options)
      puts "************"
      puts Net::HTTP.method(:get).source_location
      puts "************"
      WebMock.allow_net_connect!
      response = Net::HTTP.get(options[:host], "/json", options[:port])
      # TODO handle unsuccesful request
      response = JSON.parse(response)

      first_page = response.find {|e| e["type"] == "page"}
      # TODO handle no entry found
      first_page["webSocketDebuggerUrl"]
    end
  end
end
