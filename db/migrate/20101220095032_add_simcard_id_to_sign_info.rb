class AddSimcardIdToSignInfo < ActiveRecord::Migration
  def self.up
    change_table(:sign_infos) do |t|
      t.string :sim_card_id, :null => false, :default => '9'
    end
  end

  def self.down
    change_table(:sign_infos) do |t|
      t.remove :sim_card_id
    end
  end
end
