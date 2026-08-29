class AddUniqueIndexToBoardsTitle < ActiveRecord::Migration[8.1]
  def change
    add_index :boards, :title, unique: true
  end
end
