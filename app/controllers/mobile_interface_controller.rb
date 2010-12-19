class MobileInterfaceController < ApplicationController
  def do_post
    if request.post?
      data = request.raw_post
      io   = StringIO.new(data)
      obj  = StreamUtil.new(io).read_from_stream
      io.close
      logger.debug(obj.inspect)
    end
  end

end
