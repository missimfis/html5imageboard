class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :data
      t.date :created_at
      t.string :title
      t.string :description
      t.references :image_thread

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
