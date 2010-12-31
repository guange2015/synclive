class ContactInfo < ActiveRecord::Base
  belongs_to :user_info

  def self.add_contact_list(sim_card_id, contact_list)
    user_info = UserInfo.find_by_sim_card_id sim_card_id
    unless user_info
      1
    else
      contact_list.each do |number, name|
        contact = ContactInfo.create!(:user_info => user_info,
                           :name       => name,
                           :phone => number)
      end      
      0
    end

  end
  
end
