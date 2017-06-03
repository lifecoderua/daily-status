get '/' do
  "# Daily Status Slack bot backend online<br>
  # Welcome aboard!"
end

post '/*' do
  json: {
    text: "Catch on #{request.path}",
    attachments: [
      { text: request.body }
    ]
  }
end