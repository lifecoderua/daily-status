class Talker
  def initialize(user_id)
    @user_id = user_id
    @status = Status.get(@user_id)
  end

  # def init
  #
  # end

  def store_answer(answer)
    @status.answers.push(answer)
    @status.save
  end

  def next_question
    Question.get(@status.answers.length)
  end

  def report
    Question.all.map.with_index do |question, i|
      [question, @status.answers[i]]
    end
  end

  def self.groom(payload)
    p payload.inspect
    return {} if 'bot_message' === payload['subtype']
    return { challenge: payload['challenge'] } if payload['challenge']

    return {
        text: "Yay, I'm answer!",
        attachments: [
            { text: payload['text'] }
        ]
    }
  end
end