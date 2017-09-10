class Question
  def self.get(question_order)
    QUESTIONS[question_order] rescue nil
  end

  def self.next(question_order)
    self.get question_order + 1
  end

private
  QUESTIONS = [
      'What have you completed today?',
      'Need to close any code review?',
      'Reviewed something today?',
      'What do you plan to complete by the next meeting?',
      'What is getting in your way?',
  ]
end