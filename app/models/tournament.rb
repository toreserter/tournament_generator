require 'scheduler'
require 'club_list'
class Tournament < ActiveRecord::Base
  TYPES = %w(league knockout)
  RULE_SETS = {league: ['cycle', 'grouped', 'group_count']}
  GROUPS = %w(A B C D E F G H)
  attr_accessor :number_of_players, :cycle, :grouped, :group_count
  has_many :players, dependent: :destroy
  has_many :matches, dependent: :destroy
  accepts_nested_attributes_for :players

  after_create :create_players
  before_create :set_state
  before_save :set_rules
  validates :name, :tournament_type, :presence => true

  serialize :rules

  def in_setup?
    self.state == "in_setup"
  end

  def ready?
    self.state == "ready"
  end

  def set_fixture
    if tournament_type == "league"
      if self.rules[:grouped]
        self.set_groups
        teams = []
        self.get_groups.each do |gr|
         teams << players.where(:group => gr).map(&:id)
        end
      else
        teams = [players.map(&:id)]
      end
      schedule = Scheduler::Schedule.new(
          #array of teams that will compete against each other. If you group teams into multiple flights (divisions),
          #a separate round-robin is generated in each of them but the "physical constraints" are shared
          :teams => teams,

          #Setup some scheduling rules
          :rules => [
              # Scheduler::Rule.new(:wday => 3, :gt => ["7:00PM", "9:00PM"], :ps => ["field #1", "field #2"]),
              Scheduler::Rule.new(:wday => 5, :gt => ["7:00PM"], :ps => ["field #1"])
          ],
          :cycles => self.rules[:cycle].to_i,
          :shuffle => true
      ).generate
      schedule.rounds.each do |round|
        round.each do |rr|
          rr.games.each do |game|
            unless [game.team_a, game.team_b].include?(:dummy)
              self.matches.create(home_team_id: game.team_a, away_team_id: game.team_b, round: rr.round_with_cycle, group: (self.rules[:grouped] ? Player.find(game.team_a).group : nil))
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

  def get_groups
    GROUPS.first(self.rules[:group_count].to_i)
  end

  def completed_ratio
    ((matches.completed.count.to_f / matches.count.to_f) * 100).to_i
  end

  protected
  def create_players
    self.number_of_players.to_i.times do
      i = self.players.new(name: ClubList::LIST[rand(628)])
      i.save(validate: false)
    end
  end

  def set_state
    self.state = "in_setup"
    self.rules = {}
  end

  def set_rules
    self.rules[:cycle] = self.cycle unless self.cycle.nil?
    self.rules[:grouped] = self.grouped unless self.grouped.nil?
    self.rules[:group_count] = self.group_count unless self.group_count.nil?
  end

  def set_groups
    groups_array = get_groups * 100
    self.players.each do |player|
      player.update_attribute(:group, groups_array.shift)
    end
  end

end
