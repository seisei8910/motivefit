class RemoveFitnessAtFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :fitness_at, :datetime
  end
end
