class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :user_tournaments
  has_many :tournaments, through: :user_tournaments

  def full_name
    if firstname.blank? && lastname.blank?
      email
    else
      "#{firstname} #{lastname}"
    end
  end
end
