module CleanersHelper

  def cities_checked?(current_list, target_city)
    checked = false
    if current_list.present?
      checked = true if current_list.include?(target_city)
    end
    checked
  end

end
