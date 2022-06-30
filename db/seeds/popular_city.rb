popular_cities = ['Islamabad', 'Karachi', 'Lahore', 'Peshawar', 'Faisalabad', 'Quetta', 'Gujranwala', 'Rawalpindi', 'Multan']

popular_cities.each do |pc|
  City.where(title: pc).update(city_type: "popular")
end