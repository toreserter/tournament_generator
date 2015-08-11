class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :home_team_score
      t.integer :away_team_score
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :tournament_id

      t.timestamps null: false
    end
    add_index :matches, :tournament_id
  end
end
