class Tournament < ActiveRecord::Base
  TYPES = %w(league knockout)

  attr_accessor :number_of_players
  has_many :players, dependent: :destroy
  has_many :matches, dependent: :destroy
  accepts_nested_attributes_for :players

  # after_create :create_players
  #
  # private
  # def create_players
  #   self.number_of_players.times do
  #     self.players.create
  #   end
  # end
end
