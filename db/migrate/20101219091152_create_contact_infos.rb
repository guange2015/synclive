class CreateContactInfos < ActiveRecord::Migration
  def self.up
    create_table :contact_infos do |t|
      t.references :user_info
      t.string :phone
      t.string :name
      t.string :my_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_infos
  end
end
