class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :svg
      t.string :title
      t.string :description
      t.references :board

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
