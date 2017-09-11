require 'net/http'

class Slack
  API_URL = 'https://slack.com/api/'

  def initialize
    @token = ENV['BOT_TOKEN']
  end

  def post(channel, text, attachments=[])
    run 'chat.postMessage', {
      channel: channel, # 'updates' || 'C492503HT' || 'U.....'
      text: text,
      attachments: attachments,
      as_user: true,
    }
  end

  def room_members(channel)
    endpoint = 'G' === channel[0] ? 'groups.info' : 'channels.info'

    run(endpoint, {
        channel: channel
    })['group']['members']
  end

private

  def run(endpoint, payload)
    payload ||= {}
    payload[:token] = @token
    endpoint = URI.parse(API_URL + endpoint)

    # TODO: check codes, test for {ok: true}
    JSON.parse Net::HTTP.post_form(endpoint, payload).body
  end
end