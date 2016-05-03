Rails.application.routes.draw do

  root  'services#landing'

  post  'customer-enquiry'                                                         => 'services#customer_enquiry', as: 'customer_enquiry'
  get   'customer/:customer_id/service-requirements'                                => 'services#service_requirements', as: 'service_requirements'
  post  'customer/:customer_id/service-requirements'                               => 'services#service_requirements'
  get   'booking/:booking_id/complete'                                              => 'services#complete_booking', as: 'complete_booking'

  devise_for :users

  authenticate :user, lambda { |u| u.admin? } do
    resources :bookings
    resources :cities
    resources :cleaners
    resources :customers
  end


end
