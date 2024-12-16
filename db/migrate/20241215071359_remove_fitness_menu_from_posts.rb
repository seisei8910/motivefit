class RemoveFitnessMenuFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :fitness_menu, :string
  end
end
