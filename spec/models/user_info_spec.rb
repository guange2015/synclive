require 'spec_helper'

describe UserInfo do

  before(:each) do
    @sim_card_id = "1"*16
    @sim_card_id2 = "2"*16
    UserInfo.create ({:sim_card_id => @sim_card_id, :phone =>"11111111"})
    UserInfo.create ({:sim_card_id => @sim_card_id2, :phone =>""})
  end

  describe "add user by sim card id" do
    it "should be not return zero when user already exits" do
      UserInfo.create_by_sim_card_id(@sim_card_id).should_not == 0
    end

    it "should be return 2 when exits user finished register" do
      UserInfo.create_by_sim_card_id(@sim_card_id).should == 2
    end

    it 'should be return 1 when exits user haven\'t upload phone number' do
      UserInfo.create_by_sim_card_id(@sim_card_id2).should == 1
    end
  end
end