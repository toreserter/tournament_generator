require 'scheduler'
require 'club_list'
class Tournament < ActiveRecord::Base
  TYPES = %w(league knockout)

  attr_accessor :number_of_players
  has_many :players, dependent: :destroy
  has_many :matches, dependent: :destroy
  accepts_nested_attributes_for :players

  after_create :create_players
  before_create :set_state
  validates :name, :tournament_type, :presence => true

  def in_setup?
    self.state == "in_setup"
  end

  def ready?
    self.state == "ready"
  end

  def set_fixture
    if tournament_type == "league"
      # tournament_players = self.players
      # rounds_count = tournament_players.count - 1
      # self.players.each_with_index do |pl, index|
      #   for i in 0..rounds_count
      #     self.matches.create(home_team_id: pl.id, away_team_id: tournament_players[(rounds_count - i)].id)
      #   end
      # end
      #
      schedule = Scheduler::Schedule.new(
          #array of teams that will compete against each other. If you group teams into multiple flights (divisions),
          #a separate round-robin is generated in each of them but the "physical constraints" are shared
          :teams => [players.map(&:id)],

          #Setup some scheduling rules
          :rules => [
              # Scheduler::Rule.new(:wday => 3, :gt => ["7:00PM", "9:00PM"], :ps => ["field #1", "field #2"]),
              Scheduler::Rule.new(:wday => 5, :gt => ["7:00PM"], :ps => ["field #1"])
          ],
          :cycles => 2,
          :shuffle => true
      ).generate
      schedule.rounds.each do |round|
        round.each do |rr|
          rr.games.each do |game|
            unless [game.team_a,game.team_b].include?(:dummy)
              self.matches.create(home_team_id: game.team_a, away_team_id: game.team_b, round: rr.round_with_cycle)
            end
          end
        end
      end
      #
    end
  end

  def simulate_all
    matches.each { |m| m.simulate }
  end

  private
  def create_players
    self.number_of_players.to_i.times do
      i = self.players.new(name: ClubList::LIST[rand(628)])
      i.save(validate: false)
    end
  end

  def set_state
    self.state = "in_setup"
  end
end
