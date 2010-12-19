class CreateSignInfos < ActiveRecord::Migration
  def self.up
    create_table :sign_infos do |t|
      t.references :user_info
      t.string :content
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :sign_infos
  end
end
