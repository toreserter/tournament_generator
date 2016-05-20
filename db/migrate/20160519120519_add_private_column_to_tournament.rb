class AddPrivateColumnToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :is_private, :boolean, :default => false
  end
end
