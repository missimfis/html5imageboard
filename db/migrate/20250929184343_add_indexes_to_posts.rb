class AddIndexesToPosts < ActiveRecord::Migration[7.1]
  def change
    add_index :posts, :created_at
  end
end
