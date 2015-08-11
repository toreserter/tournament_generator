class Tournament < ActiveRecord::Base
  TYPES = %w(league knockout)

  attr_accessor :number_of_players
  has_many :players, dependent: :destroy
  has_many :matches, dependent: :destroy
  accepts_nested_attributes_for :players

  after_create :create_players
  before_create :set_state

  def in_setup?
    self.state == "in_setup"
  end

  def ready?
    self.state == "ready"
  end

  def set_fixture
    if tournament_type == "league"
      tournament_players = self.players
      rounds_count = tournament_players.count - 1
      self.players.each_with_index do |pl, index|
        for i in 0..rounds_count
          self.matches.create(home_team_id: pl.id, away_team_id: tournament_players[(rounds_count - i)].id)
        end
      end
    end
  end
  private
  def create_players
    self.number_of_players.to_i.times do
      i = self.players.new
      i.save(validate: false)
    end
  end

  def set_state
    self.state = "in_setup"
  end
end
