language = ["English", "Urdu", "Punjabi", "Sindhi", "Saraiki", "Pashto", "Balochi", "Hindko","Brahui",
  "Kashmiri", "Bengali"]


  language.each do |l|
    Language.create(title: l)
  end