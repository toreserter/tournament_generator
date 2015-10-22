class Match < ActiveRecord::Base
  GOAL_RANGES = {}
  GOAL_RANGES[0] = (0..23).to_a
  GOAL_RANGES[1] = (24..50).to_a
  GOAL_RANGES[2] = (51..65).to_a
  GOAL_RANGES[3] = (66..75).to_a
  GOAL_RANGES[4] = (76..85).to_a
  GOAL_RANGES[4] = (86..91).to_a
  GOAL_RANGES[5] = (92..95).to_a
  GOAL_RANGES[6] = (96..98).to_a
  GOAL_RANGES[7] = (99..100).to_a

  belongs_to :tournament, class_name: "Tournament", :foreign_key => 'tournament_id'
  belongs_to :home_team, class_name: "Player"
  belongs_to :away_team, class_name: "Player"

  validate :same_team_validation
  after_update :set_player_datum
  validates :home_team_score, :away_team_score, numericality: { greater_than_or_equal_to: 0, allow_nil: true}

  def self.completed
    where("home_team_score IS NOT NULL AND away_team_score IS NOT NULL")
  end

  def players
    [self.home_team, self.away_team]
  end

  def simulate
    hor_num = rand(100)
    awr_num = rand(100)
    (0..7).to_a.each do |i|
      self.home_team_score = i if GOAL_RANGES[i].member?(hor_num)
      self.away_team_score = i if GOAL_RANGES[i].member?(awr_num)
    end
    self.save!
  end

  private
  def set_player_datum
    players.each { |p| p.set_values }
  end

  def same_team_validation
    return true if home_team_id != away_team_id
    errors.add(:base, "Team cannot play with itself")
  end

end
