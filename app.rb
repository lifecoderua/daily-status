# TODO: status template
# TODO: extract app parts, bring structure
# TODO: section defaults, partial updates
# TODO: weekly status reminder
# TODO: show last 3 work days to-review aggregation (excluding own)
# TODO: status mailer
# TODO: indicate user missing status
# TODO: ping-notify users about submission required

# Iteration 2
# TODO: event subscriptions

if (ENV['RACK_ENV'] == 'development')
  require('dotenv/load')
end

require 'net/http'
require_all './model/'

configure do
  Mongoid.load!('./config/mongoid.yml.erb')
end


get '/' do
  "# Daily Status Slack bot backend online<br>
  # Welcome aboard!"

  u = User.get params[:user_id]
  s = Status.report
  # u.update params
  # u.save

  # json User.find()
  json({
    users: User.all,
    statusAll: Status.all,
    statusReport: s
  })
end


get '/poster' do
  token = ENV['BOT_TOKEN']

  return p token
  ## Sample Message.Post
  # uri = URI.parse('https://slack.com/api/chat.postMessage')
  # json Net::HTTP.post_form(uri, {
  #   token: token,
  #   channel: 'updates',
  #   text: '2 woof!'
  # })
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

  request.body.rewind
  request_payload = JSON.parse request.body.read

  p request_payload.inspect
  reply = { challenge: request_payload['challenge'] }

  json reply
end



