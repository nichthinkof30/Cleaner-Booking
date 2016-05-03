class ServicesController < ApplicationController

  skip_before_filter :authenticate_user!

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

  def customer_enquiry
    @exist_customer = Customer.find_by_phone_number(customer_params[:phone_number])
    if @exist_customer.blank?
      @customer = Customer.new(customer_params)
    end

    respond_to do |format|
      if @exist_customer.present?
        format.html { redirect_to service_requirements_path(customer_id: @exist_customer.id), notice: "Welcome Back, #{@exist_customer.first_name}" }
      elsif @customer.save
        format.html { redirect_to service_requirements_path(customer_id: @customer.id), notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render 'landing' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete_booking
    @booking = Booking.find(params[:booking_id])

    if @booking.blank?
      redirect_to root_path, notice: 'Booking Not Found'
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :phone_number)
  end

end