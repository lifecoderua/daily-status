require "sinatra/json"

get '/' do
  "# Daily Status Slack bot backend online<br>
  # Welcome aboard!"
end

post '/*' do
  reply = {
    text: "Catch on #{request.path}",
    attachments: [
      { text: params.to_s }
    ]
  }

  json reply
end