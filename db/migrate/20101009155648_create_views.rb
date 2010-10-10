class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.integer :url_id
      t.datetime :access_time
      t.string :referrer
      t.string :user_agent
      t.string :remote_ip

      t.timestamps
    end
  end

  def self.down
    drop_table :views
  end
end
