class SignInfo < ActiveRecord::Base
  belongs_to :user_info
  validates_presence_of :user_info_id
  validates_presence_of :content

  def self.modify_sign_info(user_id, content)
    if not UserInfo.exists? user_id
      return 1
    end

    update_all(:status=>0, :user_info_id => user_id)

    sign_info = new({:user_info_id => user_id,:content => content, :status => 1})
    return 0 if sign_info.save
    return 2
  end
end
