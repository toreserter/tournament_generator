class UserTournament < ActiveRecord::Base
  belongs_to :user
  belongs_to :tournament

  after_create :set_owner_role

  private
  def set_owner_role
    if self.tournament.users.count == 1
      self.update_attribute(:role, 'owner')
    end
  end
end