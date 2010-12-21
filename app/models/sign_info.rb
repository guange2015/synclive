class SignInfo < ActiveRecord::Base
  belongs_to :user_info
  validates_presence_of :user_info_id
  validates_presence_of :content

  def self.modify_sign_info(sim_card_id, content)

    user_info = UserInfo.find_all_by_sim_card_id(sim_card_id)
    if user_info.nil?
      return 1
    end

    update_all(:status=>0, :user_info_id => user_info.id)

    sign_info = new({:user_info => user_info,:content => content, :status => 1})
    return 0 if sign_info.save
    return 2
  end
end
