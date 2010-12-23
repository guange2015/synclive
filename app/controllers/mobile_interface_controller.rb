require 'stream_util'

class MobileInterfaceController < ApplicationController
  protect_from_forgery :except => :do_post
  ERROR_EXCEPTION = 9
  PARAM_ERROR = 8

  def do_post
    out_data = nil
    begin
      data = request.raw_post
      obj = StreamUtil.read_object(data)
      obj ? logger.debug("obj = " + obj.inspect) : logger.debug("data = " +data.inspect)

      if obj.kind_of? Hash
        service_name = obj["serviceName"]
        logger.debug("service_name = "+service_name)
        out_obj = self.send(service_name, obj)
        out_data = make_return(out_obj)
      else
        out_data = make_return({:status=>PARAM_ERROR})
      end

    rescue Exception => e
      logger.error(e.message+"\n"+e.backtrace.inspect)
      out_data = make_return({:status=>ERROR_EXCEPTION,:message => e.message})
      logger.debug(out_data.inspect)
    ensure
      render :text => out_data
    end if request.post?
  end


  private
  def uu_upload_contact_list(obj)
    if obj["contact_list"].nil?
      PARAM_ERROR
    else
      ContactInfo.add_contact_list(obj["sim_card_id"],
                              obj["contact_list"])
    end
  end

  def uu_refresh_contacts_signinfo(obj)

  end

  def uu_modify_sign_info(obj)
    logger.info("uu_modify_sign_info")
    code = SignInfo.modify_sign_info(obj["sim_card_id"],obj["content"])
    {:status => code}
  end

  def uu_register(obj)
    logger.info("uu_register")
    code = UserInfo.create_by_sim_card_id(obj["sim_card_id"])
    out_obj = \
    if code == 0
       {"sim_card_id" => obj["sim_card_id"],
             "sms_number" => '13712345678'}
    else
      {}
    end

    {:status => code}.merge out_obj
  end
  
  def make_return(obj)
    comm_response = CommResponse.new(0, obj)
    comm_response.out
  end

  

end
