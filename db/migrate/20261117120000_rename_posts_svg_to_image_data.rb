class RenamePostsSvgToImageData < ActiveRecord::Migration[8.1]
  def change
    rename_column :posts, :svg, :image_data
  end
end
