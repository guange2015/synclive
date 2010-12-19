class ContactsController < ApplicationController
  protect_from_forgery :except => :upload
  
  def index
    @contacts = Contact.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  def upload
    data = request.raw_post
    io = StringIO.new(data)
    obj = StreamUtil.new(io).read_from_stream
    io.close
    logger.debug(obj.inspect)
  end

  def download
  
    begin
        json_data = Contact.to_json_data
        render :text => json_data
    rescue Exception => e
        render :text => {:status => "fail",:message => "#{e}" }.to_json
    End

  end

end
