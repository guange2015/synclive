class UserInfo < ActiveRecord::Base

  attr_accessible :id
  validates_presence_of :id
  
  def self.create_by_id(id)
    begin
    user_info = self.find(id)
    if not user_info.phone.nil?
      return 2
    elsif not user_info.id.nil?
        return 1
    end
    rescue ActiveRecord::RecordNotFound
      self.create(:id => id)
    end
    return 0
  end
end
