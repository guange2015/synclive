class UserInfo < ActiveRecord::Base

  attr_accessible :id
  validates_presence_of :id
  
  def self.create_by_sim_card_id(sim_card_id)
    begin
    user_info = self.find_by_sim_card_id(sim_card_id)
    if not user_info.phone.nil?
      return 2
    elsif not user_info.id.nil?
        return 1
    end
    rescue ActiveRecord::RecordNotFound
      self.create(:sim_card_id => sim_card_id)
    end
    return 0
  end
end
