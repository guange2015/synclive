class UserInfo < ActiveRecord::Base
  
  def self.create_by_sim_card_id(sim_card_id)
    user_info = self.find_by_sim_card_id(sim_card_id)
    unless user_info
      self.create(:sim_card_id => sim_card_id)
      return 0
    else
      if not user_info.phone.empty?
        return 2
      elsif not user_info.id.nil?
          return 1
      end
    end
  end
end
