class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table <%= acts_as_history_table_name[0] %> do |t|
      t.string   :owner_type
      t.integer  :owner_id
      t.string   :type
      t.column   :value, :blob
      t.datetime :date
      t.timestamps
    end

    add_index :histories, :owner_type
    add_index :histories, :owner_id
    add_index :histories, :type
    add_index :histories, :date
  end

  def self.down
    drop_table <%= acts_as_history_table_name[0] %>
  end
  
end