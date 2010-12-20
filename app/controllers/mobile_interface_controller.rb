require 'stream_util'

class MobileInterfaceController < ApplicationController
  protect_from_forgery :except => :do_post
  ERROR_EXCEPTION = 9

  def do_get
    debugger
  end
  
  def do_post
    begin
      data = request.raw_post
      logger.debug(data.inspect)
      obj = read_object(data)
      logger.debug(obj.inspect)

      if obj.kind_of? Hash
        service_name = obj["serviceName"]
        logger.debug("service_name = "+service_name)
        code         = self.send(service_name, obj)
        render :text => make_return(code)
      end

    rescue Exception => e
      logger.error(e.message)
      out_data = make_return(ERROR_EXCEPTION)
      logger.debug(out_data.inspect)
      render :text => out_data
    end if request.post?
  end


  private  
  def uu_modify_sign_info(obj)
    logger.info("uu_modify_sign_info")
    SignInfo.modify_sign_info(obj["simcard"],obj["content"])
  end

  def uu_register(obj)
    logger.info("uu_register")
    UserInfo.create_by_id(obj["simcard"])
  end
  
  def make_return(code)
    comm_response = CommResponse.new(0, {"status"=>code.to_s})
    comm_response.out
  end

  def read_object(data)
    io           = StringIO.new(data)
    stream_util  = StreamUtil.new(io)
    is_compress  = stream_util.read_byte
    is_encrypt   = stream_util.read_byte

    service_name = stream_util.read_from_stream
    logger.debug("service_name = #{service_name}")
    logger.debug("encrypt = #{is_encrypt} , compress = #{is_compress}")
    obj = stream_util.read_from_stream
    io.close
    obj
  end

end
