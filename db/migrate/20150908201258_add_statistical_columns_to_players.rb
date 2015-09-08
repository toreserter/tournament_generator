class AddStatisticalColumnsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :played, :integer
    add_column :players, :score, :integer
    add_column :players, :win, :integer
    add_column :players, :draw, :integer
    add_column :players, :loss, :integer
    add_column :players, :goal_scored, :integer
    add_column :players, :goal_conceeded, :integer
    add_column :players, :average, :integer
  end
end
