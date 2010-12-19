class CreateUserInfos < ActiveRecord::Migration
  def self.up
    create_table :user_infos do |t|
      t.string :id
      t.string :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :user_infos
  end
end
