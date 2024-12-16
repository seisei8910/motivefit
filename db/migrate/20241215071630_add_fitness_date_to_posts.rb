class AddFitnessDateToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :fitness_date, :date
  end
end
