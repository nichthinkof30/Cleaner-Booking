class City < ActiveRecord::Base

  has_many :working_cities
  has_many :cleaners, through: :working_cities

  scope :ascending, -> { order('name ASC') }

  validates :name, presence: true

end
