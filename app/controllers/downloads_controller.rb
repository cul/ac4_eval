class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior
  # Overrides necessary pending https://github.com/projecthydra/active_fedora/issues/992
  def send_file_contents
    self.status = 200
    prepare_file_headers
    hdrs = file.headers(nil, file.send(:authorization_key))
    stream_body FileBody.new(URI.parse(file.uri), hdrs)
  end

  class FileBody
    attr_reader :uri, :headers
    def initialize(uri, headers)
      @uri = uri
      @headers = headers
    end

    def each(no_of_requests_limit = 3, &block)
      raise ArgumentError, 'HTTP redirect too deep' if no_of_requests_limit == 0
      len = 0
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri, headers
        http.request request do |response|
          case response
          when Net::HTTPSuccess
            response.read_body do |chunk|
              yield chunk
            end
          when Net::HTTPRedirection
            no_of_requests_limit -= 1
            @uri = URI(response["location"])
            each(no_of_requests_limit, &block)
          else
            raise "Couldn't get data from Fedora (#{uri}). Response: #{response.code}"
          end
        end
      end
    end
  end
end
