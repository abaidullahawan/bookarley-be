category = ["Tractors", "Farming Equipments", "Accessories and Parts",
  "Fertilizers and Seeds", "Plants and Horticulture"]



  category.each do |c|
    ProductCategory.create(title: c, status: "active")
  end