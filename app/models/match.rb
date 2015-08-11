class Match < ActiveRecord::Base
  belongs_to :tournament, class_name: "Tournament", :foreign_key => 'tournament_id'
  belongs_to :home_team, class_name: "Player"
  belongs_to :away_team, class_name: "Player"

  validate :same_team_validation

  private

  def same_team_validation
    return true if home_team_id != away_team_id
    errors.add(:base, "Team cannot play with itself")
  end
end
