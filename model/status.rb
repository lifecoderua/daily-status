class Status
  include Mongoid::Document

  field :type, default: 'daily'
  # validates_exclusion_of :type, in: [ 'daily', 'weekly' ]
  field :date, type: Time, default: ->{ Time.now }
  field :user_id
  validates_presence_of :user_id

  field :answers, default: []

  def self.get(user_id)
    self.where(date: { '$gte' => self.start_of_the_day })
      .find_or_create_by( user_id: user_id )
  end

private

  def self.start_of_the_day
    Date.today.to_time
  end

end