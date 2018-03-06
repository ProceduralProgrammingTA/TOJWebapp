class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:name]

  validates_uniqueness_of :name
  validates_presence_of :name

  def email_required?
    false
  end

  def email_changed?
    false
  end

  has_many :submissions
  has_many :reports
end
