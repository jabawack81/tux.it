class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.string :address
      t.string :remote_ip
      t.timestamps
    end
  end

  def self.down
    drop_table :urls
  end
end
