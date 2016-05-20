class CreateUserTournament < ActiveRecord::Migration
  def change
    create_table :user_tournaments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :tournament, index: true
      t.string :role
      t.timestamps null: false
    end
  end
end
