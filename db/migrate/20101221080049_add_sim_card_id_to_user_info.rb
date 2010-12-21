class AddSimCardIdToUserInfo < ActiveRecord::Migration
  def self.up
    change_table(:user_infos) do |t|
      t.string :sim_card_id, :null => false, :default => '9'
    end
  end

  def self.down
    change_table(:user_infos) do |t|
      t.remove :sim_card_id
    end
  end
end
