class Player < ActiveRecord::Base
  belongs_to :tournament
  has_many :home_matches, class_name: "Match", foreign_key: "home_team_id"
  has_many :away_matches, class_name: "Match", foreign_key: "away_team_id"


  validates :name, :team, :presence => true

  def set_values
    h = {played: 0, score: 0, win: 0, loss: 0, draw: 0, goal_scored: 0, goal_conceeded: 0, average: 0}
    home_matches.completed.each do |hm|
      r = self.process_match(hm)
      r.keys.each do |key|
        h[key] += r[key]
      end
    end
    away_matches.completed.each do |hm|
      r = self.process_match(hm)
      r.keys.each do |key|
        h[key] += r[key]
      end
    end
    self.update(h)
  end

  def self.order_players
    order("score desc, average desc, goal_scored desc")
  end

  def process_match(match)
    win=0; draw=0; loss=0;
    if self.id == match.home_team_id
      location = "home"
      r_location = "away"
    elsif self.id == match.away_team_id
      location = "away"
      r_location = "home"
    else
      #HATA
    end
    team_goal_scored = match.send("#{location}_team_score")
    team_goal_conceeded = match.send("#{r_location}_team_score")
    average = team_goal_scored - team_goal_conceeded
    if average > 0
      score = 3
      win = 1
    elsif average == 0
      score = 1
      draw = 1
    else
      score = 0
      loss = 1
    end
    {played: 1, score: score, win: win, draw: draw, loss: loss, goal_scored: team_goal_scored, goal_conceeded: team_goal_conceeded, average: average}
  end
end
