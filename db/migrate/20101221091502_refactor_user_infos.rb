class RefactorUserInfos < ActiveRecord::Migration
  def self.up
    drop_table :user_infos
    create_table :user_infos do |t|
      t.string :phone
      t.string :sim_card_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_infos
  end
end
