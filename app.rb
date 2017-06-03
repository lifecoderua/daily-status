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
post '/daily' do
  reply = {
    text: "Status stored!",
    attachments: [
      { text: params['text'].to_s }
    ]
  }

  json reply
end