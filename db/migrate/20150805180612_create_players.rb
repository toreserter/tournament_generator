class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :team
      t.integer :tournament_id

      t.timestamps null: false
    end
    add_index :players, :tournament_id
  end
end
