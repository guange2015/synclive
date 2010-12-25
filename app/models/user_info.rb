class UserInfo < ActiveRecord::Base
  has_many :contact_infos
  has_many :sign_infos
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

  def get_contacts_sign_info
    l = []
    for contact in contact_infos
      unless contact.my_user_id.empty?
        user = UserInfo.find(contact.my_user_id)
        if user and user.active_sign_info
          l << [user.id, user.phone, user.active_sign_info.content ]  
        end
      end
    end
    l
  end

  def self.update_phone(phone, sim_card_id)
    user = UserInfo.find_by_sim_card_id sim_card_id
    user.phone = phone
    user.save
  end

  def active_sign_info
    sign_infos.find_by_status(1)
  end

  def registered?
    !(phone.nil?) && !(phone.empty?) 
  end
end
