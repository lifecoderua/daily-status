# TODO: status template
# TODO: extract app parts, bring structure
# TODO: section defaults, partial updates
# TODO: weekly status reminder
# TODO: show last 3 work days to-review aggregation (excluding own)
# TODO: status mailer
# TODO: indicate user missing status
# TODO: ping-notify users about submission required

require_all './model/'


configure do
  Dotenv.load
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

  reply = {data: Command.new(params).result}

  json reply
end



