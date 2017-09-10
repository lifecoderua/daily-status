require 'net/http'

class Slack
  API_URL = 'https://slack.com/api/'

  def initialize
    @token = ENV['BOT_TOKEN']
  end

  def post(channel, text)
    run 'chat.postMessage', {
      channel: channel, #'updates',
      text: text #'2 woof!'
    }
  end

private

  def run(endpoint, payload)
    payload ||= {}
    payload[:token] = @token
    endpoint = URI.parse(API_URL + endpoint)

    Net::HTTP.post_form(endpoint, payload)
  end
end