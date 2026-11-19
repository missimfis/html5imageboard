class AddOwnerTokenToBoardsAndPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :boards, :owner_token, :string
    add_column :posts, :owner_token, :string
  end
end
