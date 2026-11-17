class AddConstraintsAndIndexesToPostsAndBoards < ActiveRecord::Migration[8.1]
  def up
    change_column :posts, :description, :text

    change_column_null :boards, :title, false
    change_column_null :posts, :title, false
    change_column_null :posts, :image_data, false
    change_column_null :posts, :board_id, false

    add_foreign_key :posts, :boards
    add_index :boards, :created_at

    remove_index :posts, :board_id
    add_index :posts, %i[board_id created_at]
  end

  def down
    remove_index :posts, %i[board_id created_at]
    add_index :posts, :board_id

    remove_index :boards, :created_at
    remove_foreign_key :posts, :boards

    change_column_null :posts, :board_id, true
    change_column_null :posts, :image_data, true
    change_column_null :posts, :title, true
    change_column_null :boards, :title, true

    change_column :posts, :description, :string
  end
end
