require "spec_helper"
require 'stream_util'

describe MobileInterfaceController do

  def raw_post(action, params, body)
    request.env['RAW_POST_DATA'] = body
    response                     = post(action, params)
    request.env.delete('RAW_POST_DATA')
    response
  end

  def do_do_post(data)
    raw_post :do_post, nil, data
    StreamUtil.read_return_object(response.body)
  end


  before(:each) do
    @sim_card_id  = "1"*15
    @sim_card_id2 = "2"*15
  end 

  def make_post_data(data)
    CommRequest.new("uu_service",
                    {"sim_card_id" => @sim_card_id}.merge(data)).out
  end

  def register_user(sim_card_id='')
    data = make_post_data({"serviceName"=>"uu_register", "sim_card_id" => sim_card_id})
    do_do_post(data)
  end

  describe "POST do_post" do
    it "has a error status when all data post" do
      do_do_post('some error data')["status"].should_not == "0"
    end
  end

  describe "register user" do
    it "should has a error status when haven't put sim card id" do
      register_user('')["status"].should_not == "0"
    end

    it "should has a success status when have right data post" do
      h = register_user(@sim_card_id)
      h["status"].should == "0"
      h["sms_number"].should_not be_empty
      h["sim_card_id"].should_not be_empty
    end

    it "should return 1 when sim card id is exits" do
      register_user(@sim_card_id)["status"].should == "0"
      register_user(@sim_card_id)["status"].should == "1"
    end

    it "should return 2 when sim card id is registered." do
      register_user(@sim_card_id)["status"].should == "0"
      get :upload_phone, {:phone => "15812345678", :sim_card_id => @sim_card_id}
      register_user(@sim_card_id)["status"].should == "2"
    end
  end

  describe 'finish user\'s phone' do
    before(:each) do
      register_user(@sim_card_id)
    end

    it "should get success when put phone number and sim card id is registered" do
      get :upload_phone, {:phone => "15812345678", :sim_card_id => @sim_card_id}
      response.body.should =~ /success/
    end

    it "should get fail when put error data" do
      get :upload_phone, {:phone => "15812345678"}
      response.body.should_not =~ /success/
      get :upload_phone, {}
      response.body.should_not =~ /success/
    end
  end

  describe "modify sign info" do
    it "should has a error status when haven't put content" do
      data = make_post_data({"serviceName"=>"uu_modify_sign_info",
                             "content"    =>''})
      do_do_post(data)["status"].should_not == "0"
    end
    it "should return 1 when sim card id haven't register" do
      data = make_post_data({"serviceName"=>"uu_modify_sign_info",
                             "content"    =>'test data'})
      do_do_post(data)["status"].should == "1"
    end
    it "should return 0 when sim card id  registered" do
      register_user(@sim_card_id)
      data = make_post_data({"serviceName"=>"uu_modify_sign_info",
                             "content"    =>'test data'})
      do_do_post(data)["status"].should == "0"
    end
  end

  describe "upload contact list" do
    before(:each) do
      register_user(@sim_card_id)
    end
    it "should have a error status when haven't given contact list" do
      data = make_post_data({"serviceName"=>"uu_upload_contact_list"
                            })
      do_do_post(data)["status"].should_not == "0"
    end
    it "should return 0 when given contact list" do
      data = make_post_data({"serviceName"  =>"uu_upload_contact_list",
                             "contact_list" => {"1581234567"=>"test_user"}
                            })
      do_do_post(data)["status"].should == "0"
    end
  end

  describe "refresh contacts sign info" do
    before(:each) do
      register_user(@sim_card_id)
    end

    it "should have a error status when given unregister user" do
      data = make_post_data({"serviceName" =>"uu_refresh_contacts_sign_info",
                             "sim_card_id" => @sim_card_id2
                            })
      h    = do_do_post(data)
      h["status"].should_not == "0"
    end
    it "should get contacts sign info when given register user" do
      data = make_post_data({"serviceName" =>"uu_refresh_contacts_sign_info",
                             "sim_card_id" => @sim_card_id
                            })
      h    = do_do_post(data)
      h["status"].should == "0"
      h["contacts_sign_info"].should be_is_a Array
    end
  end


end

