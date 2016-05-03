Rails.application.routes.draw do

  root 'services#landing'

  get 'customer/:customer_id/service-requirements'                                => 'services#service_requirements', as: 'service_requirements'
  post 'customer/:customer_id/service-requirements'                               => 'services#service_requirements'
  get 'booking/:booking_id/complete'                                              => 'services#complete_booking', as: 'complete_booking'

  resources :bookings
  resources :cities
  resources :cleaners
  resources :customers

end
