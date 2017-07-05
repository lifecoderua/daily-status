class User
  include Mongoid::Document
  
  field :user_id
  field :team_id
  
  field :name
  field :email
  
  def self.get user_id
    self.find_or_create_by user_id: user_id
  end
end