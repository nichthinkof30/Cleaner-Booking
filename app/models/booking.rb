class Booking < ActiveRecord::Base

  after_commit :email_cleaner, on: :create

  belongs_to :customer
  belongs_to :cleaner

  delegate :first_name, :last_name, to: :cleaner, prefix: true
  delegate :first_name, :last_name, to: :customer, prefix: true

  scope :search, ->(date) { where(date: date) }
  scope :with_cleaner_ids, ->(cleaner_ids) { where(cleaner_id: cleaner_ids) }

  validates :customer, :cleaner, :date, presence: true

  def email_cleaner
    Notifier.notify(self.cleaner, self).deliver_now
  end

end
