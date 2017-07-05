class Status
  include Mongoid::Document

  field :type, default: 'daily'
  # validates_exclusion_of :type, in: [ 'daily', 'weekly' ]

  # field :current, type: Boolean
  field :date, type: Time, default: ->{ Time.now }
  field :user_id
  validates_presence_of :user_id

  field :status
  field :reviewed
  field :to_review
  field :plan_to

  REPORT_SECTIONS = ['status', 'reviewed', 'to review', 'plan to']

  def self.report
    self.where(date: { '$gte' => start_of_the_day })
  end

  def self.current user_id
    self.where(date: { '$gte' => start_of_the_day })
      .find_or_create_by( user_id: user_id )
  end

  def self.apply user_id, text_report
    report = self.current user_id
    self.parse_text_report text_report
  end

private

  def self.start_of_the_day
    Date.today.to_time
  end

  def self.parse_text_report text_report
    section = :status

    text_report.each_line do |line|
      line.strip!
      next if line.empty?

      if next_section = self.section(line)
        section = next_section
        next
      end

      # TODO: store and remove debug
      p "#{section} => #{line}"
    end
  end  

  def self.section line
    REPORT_SECTIONS.each do |test_section|      
      return test_section unless (/^#{test_section}/i =~ line).nil?        
    end

    false
  end
end