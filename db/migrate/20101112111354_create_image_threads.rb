class CreateImageThreads < ActiveRecord::Migration
  def self.up
    create_table :image_threads do |t|
      t.string :title
      t.date :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :image_threads
  end
end
