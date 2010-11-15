class ChangeStringToText < ActiveRecord::Migration
  def self.up
    change_column :views, :referrer, :text
    change_column :urls, :address, :text
  end

  def self.down
    change_column :views, :referrer, :string
    change_column :views, :address, :string
  end
end
