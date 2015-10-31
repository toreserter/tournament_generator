class AddRulesToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :rules, :text
  end
end
