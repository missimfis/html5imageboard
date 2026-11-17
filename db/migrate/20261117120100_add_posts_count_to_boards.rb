class AddPostsCountToBoards < ActiveRecord::Migration[8.1]
  def up
    add_column :boards, :posts_count, :integer, default: 0, null: false

    execute <<~SQL.squish
      UPDATE boards
      SET posts_count = (
        SELECT COUNT(*) FROM posts WHERE posts.board_id = boards.id
      )
    SQL
  end

  def down
    remove_column :boards, :posts_count
  end
end
