require "sinatra/json"

get '/' do
  "# Daily Status Slack bot backend online<br>
  # Welcome aboard!"
end


# Handle `/daily *` slack command
#
# Payload:
# params['token'] - OAuth token
# params['team_id'] + params['user_id'] - to keep track on user
# params['text'] - payload, parse for extra options
post '/slack/daily' do
  reply = {
    text: "Status stored!",
    attachments: [
      { text: params['text'].to_s }
    ]
  }

  json reply
end

# TEST: try Event-driven bot
post '/slack/event' do
  bot = Bot.new(request.body)

  # payload = JSON.parse(request.body.read).symbolize_keys
  # reply = {
  #   challenge: payload[:challenge]
  # }

  json bot.reply
end

class Bot
  def initialize(body)
    @event = JSON.parse(body.read).symbolize_keys
  end

  def reply
    self.send @event[:type]
  end

  def url_verification
    { challenge: @event[:challenge] }
  end

  def event_callback
    p @event.inspect
    { ok: 'ok' }
  end

  def method_missing
    p '### !MISSING!'
    p @event.inspect
    { ok: 'ok' }
  end
end