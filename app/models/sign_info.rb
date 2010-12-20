class SignInfo < ActiveRecord::Base
  belongs_to :user_info

  def self.modify_sign_info(user_id, content)
    if not UserInfo.exists? user_id
      return 1
    end

    update_all(:status=>0, :user_info_id => user_id)

    user_info = UserInfo.new({:content => content, :status => 1})
    user_info.save
  end
end
