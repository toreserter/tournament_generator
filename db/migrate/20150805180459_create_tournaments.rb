class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :tournament_type

      t.timestamps null: false
    end
  end
end
