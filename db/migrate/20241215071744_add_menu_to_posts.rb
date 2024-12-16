class AddMenuToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :menu, :text
  end
end
