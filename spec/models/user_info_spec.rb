require 'spec_helper'

describe UserInfo do

  before(:each) do
      UserInfo.create ({:sim_card_id => "111111", :phone =>"11111111"})
      UserInfo.create ({:sim_card_id => "222222", :phone =>""})
  end

  describe "add user sim card id already exits" do
    it "should be not return zero" do
      UserInfo.create_by_sim_card_id("111111").should_not == 0
    end

    describe "exits user finished register" do
      it "should be return 2" do
        UserInfo.create_by_sim_card_id("111111").should == 2
      end
    end

    describe "exits user haven't upload phone number" do
      it 'should be return 1' do
        UserInfo.create_by_sim_card_id("222222").should == 1
      end
    end
  end
end