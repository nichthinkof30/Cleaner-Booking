class Cleaner < ActiveRecord::Base

  attr_accessor :city_list

  has_many :working_cities
  has_many :cities, through: :working_cities
  has_many :bookings

  scope :sort_best_scores, -> { order('quality_score DESC') }

  validates :first_name, :last_name, :quality_score, :email, presence: true
  validates :email, format: { with: Devise::email_regexp }
  validates :quality_score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  def attach_working_cities(city_list)
    # Trim all blank value
    city_list.reject! { |c| c.empty? } if city_list.present?
    # Delete all working cities if present
    self.cities.delete_all if self.working_cities.present?

    new_cities = City.where(id: city_list)
    self.cities << new_cities
  end

  def working_cities_id
    self.cities.pluck(:id)
  end

  def working_cities_name
    self.cities.pluck(:name).join(', ')
  end

end
