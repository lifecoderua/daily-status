class User
  include Mongoid::Document
  
  field :user_id
  field :team_id
  
  field :name
  field :email
  
  def self.get user_id, user_name=''
    return nil unless user_id
    self.where(user_id: user_id).find_or_create_by name: user_name
  end
end