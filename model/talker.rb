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
end