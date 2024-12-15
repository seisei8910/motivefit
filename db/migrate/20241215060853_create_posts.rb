class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|

      t.integer :user_id
      t.datetime :fitness_at
      t.string :fitness_menu
      t.text :body
      t.timestamps
    end
  end
end
