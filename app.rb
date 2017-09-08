if (ENV['RACK_ENV'] == 'development')
  require('dotenv/load')
end
require 'net/http'

get '/' do
  "# Daily Status Slack bot backend online<br>
  # Welcome aboard!"
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

  reply = { challenge: request_payload['challenge'] }
  
  json reply
end

class Command
  attr_reader :action

  #TODO: better naming, maybe @ for personal information setup
  ACTIONS = %w(name email report send)

  def initialize params
    @params = params.symbolize_keys
    action, @data = /^(\!(\w+) )?(.*)/m.match(@params[:text])[2..3]
    @action = ACTIONS.include?(action) ? action.to_sym : :status
  end

  def result
    case @action
      when :status 
        "STATUS! #{@data}"
      when :name
        "@name set to #{@data}"
      when :email 
        "@email set to #{@data}"
    end
  end

end

