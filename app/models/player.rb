class Player < ActiveRecord::Base
  belongs_to :tournament
  has_many :matches

  validates :name, :team, :presence => true
end
