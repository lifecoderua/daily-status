configure do
  Dotenv.load
  db = Mongo::Client.new(ENV['db_connection'])  
  set :mongo_db, db[:test]
end

get '/' do
  "# Daily Status Slack bot backend online<br>
  # Welcome aboard!"

  p settings.mongo_db.database.collection_names.inspect
  settings.mongo_db.insert_one({ user: 'TestUser', name: 'NewName' })
  settings.mongo_db.find({}).
    find_one_and_update('$set' => {
      user: '1234', name: 'waka-waka'
    })
    # find_one_and_update('$set' => request.params)
  json document = settings.mongo_db.find().to_a.first
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

