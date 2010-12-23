class UserInfo < ActiveRecord::Base
  validates_length_of :sim_card_id, :is => 16

  def self.create_by_sim_card_id(sim_card_id)
    user_info = self.find_by_sim_card_id(sim_card_id)
    unless user_info
      self.create!(:sim_card_id => sim_card_id)
      return 0
    else
      if !(user_info.phone.nil?) && !(user_info.phone.empty?)
        return 2
      elsif not user_info.id.nil?
        return 1
      end
    end
  end
end
