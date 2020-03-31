namespace :app do
  namespace :ping do
    # rake app:ping:run
    task run: :environment do
      require 'net/http'
      require 'uri'

      api_ping_url = ENV['SHOUTOUT_APP_PING_URL']
      uri = URI.parse(api_ping_url)
      request = Net::HTTP::Get.new(uri)
      request.content_type = 'application/json'

      req_options = {
        use_ssl: uri.scheme == 'https'
      }

      say "Starting pings against #{api_ping_url}"

      loop do
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end

        if response.code.eql?('200')
          say("OK @ #{Time.zone.now}")
          sleep(300) # 5min
        else
          cmd = ['terminal-notifier']
          cmd << '-title Shoutout-Error'
          cmd << "-subtitle #{response.code}"
          cmd << '-message ALERT'
          cmd << '-sound default'
          system cmd.join(' ')

          sleep(60)
        end
      end
    end
  end
end
