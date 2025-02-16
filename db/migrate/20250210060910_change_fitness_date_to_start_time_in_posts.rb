class ChangeFitnessDateToStartTimeInPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :fitness_date, :start_time
    change_column :posts, :start_time, :datetime
  end
end
