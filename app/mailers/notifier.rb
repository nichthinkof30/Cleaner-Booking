class Notifier < ApplicationMailer

  def notify(cleaner, booking)
    @cleaner = cleaner
    @booking = booking

    mail(to: cleaner.email, subject: 'Incoming request')
  end

end
