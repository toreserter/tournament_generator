class Match < ActiveRecord::Base
  belongs_to :tournament, class_name: "Tournament", :foreign_key => 'tournament_id'
  belongs_to :home_team, class_name: "Player"
  belongs_to :away_team, class_name: "Player"

  validate :same_team_validation
  after_update :set_player_datum
  def self.completed
    where("home_team_score IS NOT NULL AND away_team_score IS NOT NULL")
  end

  def players
    [self.home_team, self.away_team]
  end

  private
  def set_player_datum
    players.each {|p| p.set_values}
  end

  def same_team_validation
    return true if home_team_id != away_team_id
    errors.add(:base, "Team cannot play with itself")
  end

end
