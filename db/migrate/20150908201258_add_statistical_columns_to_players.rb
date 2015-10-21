class AddStatisticalColumnsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :played, :integer, :default => 0
    add_column :players, :score, :integer, :default => 0
    add_column :players, :win, :integer, :default => 0
    add_column :players, :draw, :integer, :default => 0
    add_column :players, :loss, :integer, :default => 0
    add_column :players, :goal_scored, :integer, :default => 0
    add_column :players, :goal_conceeded, :integer, :default => 0
    add_column :players, :average, :integer, :default => 0
  end
end
