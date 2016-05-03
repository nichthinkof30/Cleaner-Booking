class ServicesController < ApplicationController

  skip_before_filter :authenticate

  def landing
    @customer = Customer.new
  end

  def service_requirements
    @customer = Customer.find(params[:customer_id])
    @cities = City.ascending

    if @customer.present?
      # Searching for cleaner

      if request.post?
        city = City.find(params[:city_id])

        if city.present?
          target_date = Time.parse("#{params[:date][:year]}-#{params[:date][:month]}-#{params[:date][:day]}").strftime("%Y-%m-%d")

          # Get all the cleaner correspond to the city
          cleaner_ids = city.cleaners.pluck(:id)
          # Check for booking corresponding to the city cleaners & get all the booked cleaners
          booked_cleaner_ids = Booking.with_cleaner_ids(cleaner_ids).search(target_date).pluck(:cleaner_id)
          available_cleaner_ids = cleaner_ids - booked_cleaner_ids
          @available_cleaner = Cleaner.where(id: available_cleaner_ids).sort_best_scores.first

          # Cleaner found
          if @available_cleaner.present?
            # create booking
            @booking = Booking.new(customer: @customer, cleaner: @available_cleaner, date: target_date)
            if @booking.save
              redirect_to complete_booking_path(booking_id: @booking.id), notice: 'Complete Booking'
            else
              redirect_to service_requirements_path(customer_id: @customer.id), notice: 'Something missing!'
            end
          else
            redirect_to service_requirements_path(customer_id: @customer.id), notice: 'No cleaner available, please reschedule!'
          end
        else
          redirect_to service_requirements_path(customer_id: @customer.id), notice: 'Please select city before proceed!'
        end
      end

    else
      redirect_to root_path, notice: 'Customer Not Found'
    end
  end

  def complete_booking
    @booking = Booking.find(params[:booking_id])

    if @booking.blank?
      redirect_to root_path, notice: 'Booking Not Found'
    end
  end

end