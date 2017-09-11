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

if ENV['RACK_ENV'] == 'development'
  require('dotenv/load')
end

require 'net/http'
require_all './model/'

configure do
  Mongoid.load!('./config/mongoid.yml.erb')
end


get '/' do
  '# Daily Status Slack bot backend online<br>
  # Welcome aboard!'

  # u = User.get params[:user_id]
  # s = Status.report
  # # u.update params
  # # u.save

  # json User.find()
  json({
    questions: [
        Question.next(-1),
        Question.next(0),
        Question.next(1),
        Question.next(2),
        Question.next(3),
        Question.next(4),
        Question.next(5),
    ]
    # users: User.all,
    # statusAll: Status.all,
    # statusReport: s
  })
end


# TODO: debug method, to cleanup
get '/poster' do
  token = ENV['BOT_TOKEN']

  return p token

  ## Sample Message.Post
  # token = Slack.new().post('updates', 'I am robot!')
end

# TODO: debug method, to cleanup
get '/asker' do
  # p Status.new('AB34fOO').next_question
  p Status.get('AB34fOO') #.next_question
end

get '/slacker' do
  json Slack.new.room_members('G71FJA4Q7')
end


# TODO: debug method, to cleanup
get '/talker' do
  uid = 'AS32445DJ'
  talker = Talker.new uid

  p '::>>' + talker.next_question.inspect
  talker.store_answer('one')
  p '::>>' + talker.next_question.inspect
  talker.store_answer('two')
  p '::>>' + talker.next_question.inspect
  talker.store_answer('three')

  p '::>>' + talker.report.inspect

  'yay!'
end

# Handle `/daily *` slack command
#
# Payload:
# params['token'] - OAuth token
# params['team_id'] + params['user_id'] - to keep track on user
# params['text'] - payload, parse for extra options
post '/slack/daily' do
  request.body.rewind
  payload = JSON.parse(request.body.read)

  json Talker.groom(payload)
end

