require "spec_helper"

describe SignInfo do

  describe 'add sign info' do
    before(:each) do
      @sim_card_id = "1"*15
      @sim_card_id2 = "2"*15
      @test_user = UserInfo.create(:phone => '15812345678', :sim_card_id => @sim_card_id)
      @test_sign = SignInfo.new
    end

    it "should have register user" do
      SignInfo.modify_sign_info(@sim_card_id2,'test value').should == 1
    end

    it "should success add  info of register user" do
      count = SignInfo.count
      SignInfo.modify_sign_info(@sim_card_id,'test value').should == 0
      SignInfo.count.should == count+1
    end
    
  end
end