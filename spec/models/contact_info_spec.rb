require 'spec_helper'

describe ContactInfo do

  describe "add contact list" do
    before(:each) do
      @sim_card_id = "1"*15
      @sim_card_id2 = "2"*15
      @sim_card_id3 = "3"*15
      @phone = "15812345678"
      UserInfo.create ({:sim_card_id => @sim_card_id, :phone =>"11111111"})
    end
    it "should return 1 when user not exits" do
      ContactInfo.add_contact_list(@sim_card_id2, {}).should == 1
    end

    it "should return 0 when param right" do
      ContactInfo.add_contact_list(@sim_card_id,
                {@phone => "test user"}).should == 0
    end

    it "should return 0 and update my user id when param right" do
      UserInfo.create ({:sim_card_id => @sim_card_id3, :phone =>@phone})
      ContactInfo.add_contact_list(@sim_card_id,
                {@phone => "test user"}).should == 0
      ContactInfo.where(:my_user_id => @sim_card_id3,
                        :phone => @phone).first.should_not be_nil
    end
    
  end
end