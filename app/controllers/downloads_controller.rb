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

    def each(no_of_requests_limit = 3)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        response = get_response(http, no_of_requests_limit)
        response.read_body { |chunk| yield chunk } if block_given?
      end
    end

    def get_response(http, no_of_requests_limit)
      raise ArgumentError, 'HTTP redirect too deep' if no_of_requests_limit < 1
      result = nil
      http.request Net::HTTP::Get.new(uri, headers) do |response|
        result = response if response.is_a?(Net::HTTPSuccess)
        unless result || response.is_a?(Net::HTTPRedirection)
          raise "Couldn't get data from Fedora (#{uri}). Response: #{response.code}"
        end
        @uri = URI(response["location"])
      end
      result || get_response(http, no_of_requests_limit - 1)
    end
  end
end
