require 'spec_helper'

describe UserInfo do

  before(:each) do
    UserInfo.create ({:sim_card_id => "111111", :phone =>"11111111"})
    UserInfo.create ({:sim_card_id => "222222", :phone =>""})
  end

  describe "add user by sim card id" do
    it "should be not return zero when user already exits" do
      UserInfo.create_by_sim_card_id("111111").should_not == 0
    end

    it "should be return 2 when exits user finished register" do
      UserInfo.create_by_sim_card_id("111111").should == 2
    end

    it 'should be return 1 when exits user haven\'t upload phone number' do
      UserInfo.create_by_sim_card_id("222222").should == 1
    end
  end
end