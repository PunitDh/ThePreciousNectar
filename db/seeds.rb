# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

categories = ["Chardonnay", "Rose", "Shiraz-Cabernet Sauvignon", "Cabernet Sauvignon", "Shiraz", "Grenache", "Sauvignon Blanc", "Muscat", "Muscadelle",
"Shiraz-Viognier", "Viognier", "Riesling", "Pinot Grigio", "Pinot Noir", "Red Blend", "Marsanne-Roussanne", "Sauvignon Blanc-Semillon",
"Semillon-Sauvignon Blanc", "Sparkling Blend", "Cabernet Merlot", "Cabernet Sauvignon-Merlot", "White Blend", "Champagne Blend", "Moscato",
"Shiraz-Grenache", "Semillon", "Rhone-style Red Blend", "Syrah", "Verdelho", "G-S-M", "Merlot", "Pinot Gris", "Marsanne", "Cabernet Sauvignon-Shiraz",
"Bordeaux-style Red Blend", "Sangiovese", "Chardonnay-Semillon", "Tokay", "Tempranillo", "Cabernet Sauvignon-Sangiovese", "Cabernet Blend",
"Petite Sirah", "Port", "Shiraz-Cabernet", "Grenache-Shiraz", "Malbec", "Roussanne", "Cabernet Sauvignon-Merlot-Shiraz", "Rhone-style White Blend",
"Shiraz-Malbec", "Montepulciano", "Vermentino", "Mataro", "Shiraz-Roussanne", "Mourvedre", "Cabernet-Shiraz", "Chenin Blanc", "Zinfandel",
"Viognier-Marsanne", "Savagnin", "Semillon-Chardonnay", "Durif", "Mourvedre-Syrah", "Muscat Hamburg", "Sauvignon", "Petit Verdot", "Shiraz-Mourvedre"]

categories.each { |category| Category.create(name: category) }

wine_regions = ["New South Wales", "Victoria", "South Australia", "Tasmania", "Western Australia"]

wine_regions.each { |region| Region.create(name: region) }