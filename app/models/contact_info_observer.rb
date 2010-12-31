class ContactInfoObserver < ActiveRecord::Observer
  observe ContactInfo

  def before_create(contact_info)
    
    puts "before-------------"
  end
  def after_create(contact_info)
    puts "sfsdf"
    contact_info.logger.error("model "+contact_info.inspect)
    user = UserInfo.find_by_phone contact_info.phone
    if user
      contact_info.my_user_id = user.id
      contact_info.save
    end
  end
end
