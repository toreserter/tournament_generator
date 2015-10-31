class AddGroupToPlayersAndMatches < ActiveRecord::Migration
  def change
    add_column :players, :group, :string
    add_column :matches, :group, :string
  end
end
