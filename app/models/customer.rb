class Customer < ActiveRecord::Base

  validates :first_name, :last_name, presence: true
  validates :phone_number, uniqueness: true, allow_blank: true, allow_nil: true

end