require 'csv'
require Rails.root.join('db', 'seeds', 'helpers')

metal = Category.find_by name: 'Metal'
paper = Category.find_by name: 'Paper'
glass = Category.find_by name: 'Glass'
plastic = Category.find_by name: 'Plastic'
food = Category.find_by name: 'Food'

claremont = City.create!  name: 'Claremont',
                          state: 'California',
                          latitude: 34.12,
                          longitude: -117.71,
                          location_id: 'NA-US-CA-CLAREMONT',
                          website_url: 'http://www.ci.claremont.ca.us/'

claremont.zip_codes.create! name: '91711'

claremont_recycle_bin = claremont.bins.create! name: 'recycling', color: '#0000c8'
claremont_compost_bin = claremont.bins.create! name: 'compost', color: '#A52A2A'
claremont_trash_bin = claremont.bins.create! name: 'trash', color: '#000000'

# Items for Claremont (based on the information at http://www.ci.claremont.ca.us/home/showdocument?id=610)
claremont_recycle_bin.add_items!([
  # Aluminum items
  { name: 'Aluminum soda cans', category: metal },
  { name: 'Aluminum beer cans', category: metal },
  { name: 'Fruit cans', category: metal },
  { name: 'Vegetable cans', category: metal },
  { name: 'Pet food cans', category: metal },
  { name: 'Juice cans', category: metal },
  { name: 'Soup cans', category: metal },
  { name: 'Sauce cans', category: metal },
  { name: 'Assorted food cans', category: metal },
  { name: 'Metal Hangers', category: metal },

  # Paper items
  { name: 'Junk mail', category: paper },
  { name: 'Telephone books', category: paper },
  { name: 'Catalogs', category: paper },
  { name: 'Computer paper', category: paper },
  { name: 'Envelopes', category: paper },
  { name: 'Wrapping paper', category: paper },
  { name: 'Brochures', category: paper },
  { name: 'Crayon drawings', category: paper },
  { name: 'Office paper', category: paper },
  { name: 'Copy paper', category: paper },
  { name: 'Cereal boxes', category: paper },
  { name: 'Tissue boxes', category: paper },
  { name: 'Food boxes', category: paper },
  { name: 'Milk cartons', category: paper },
  { name: 'Juice boxes', category: paper },
  { name: 'Soda/beer cartons', category: paper },
  { name: 'Egg cartons', category: paper },
  { name: 'Cardboard bags', category: paper },
  { name: 'Cardboard boxes', category: paper },
  { name: 'Gift boxes', category: paper },
  { name: 'Styrofoam packaging (large pieces)', category: paper },

  # Glass items
  { name: 'Juice bottles', category: glass },
  { name: 'Beer bottles', category: glass },
  { name: 'Wine bottles', category: glass },
  { name: 'Liquor bottles', category: glass },
  { name: 'Baby food jars', category: glass },
  { name: 'Condiment jars', category: glass },
  { name: 'Jam jars', category: glass },
  { name: 'Jelly jars', category: glass },
  { name: 'Assorted food jars', category: glass },
  { name: 'Salad dressing bottles', category: glass },

  # Plastic items
  { name: 'Plastic #1', category: plastic },
  { name: 'Plastic #2', category: plastic },
  { name: 'Plastic #3', category: plastic },
  { name: 'Plastic #4', category: plastic },
  { name: 'Plastic #5', category: plastic },
  { name: 'Plastic #6', category: plastic },

  # { name: 'Plastic water bottles', category: plastic },
  # { name: 'Plastic soda bottles', category: plastic },
  # { name: 'Plastic milk jugs', category: plastic },
  # { name: 'Plastic laundry jugs', category: plastic },
  # { name: 'Shampoo bottles', category: plastic },
  # { name: 'Lotion bottles', category: plastic },
  # { name: 'Food containers', category: plastic },
  # { name: 'Condiment bottles', category: plastic },
  # { name: 'Motor oil containers', category: plastic },
  # { name: 'Vegetable oil bottles', category: plastic },
])

# Random items for food
claremont_compost_bin.add_items!([
  # Food items
  { name: 'Organic fruit', category: food },
  { name: 'Food scraps', category: food },
  { name: 'Compostable paper plates', category: paper },
  { name: 'Biodegradable glass', category: glass },
])

claremont_trash_bin.add_items!([
  { name: 'Plastic #7', category: plastic },
])


# It's useful to have a kind of sandbox city for testing
schmorbodia = City.create!(
  name: 'Schmorbodia',
  state: 'California',  # Not actually, just has to be a valid state
  latitude: 82.86,      # It's actually in Antarctica, apparently
  longitude: 135.00,
  location_id: 'AN-AN-AN-SCHMORBODIA'
)

schmorbodia.zip_codes.create! name: '00000'
schmorbodia.zip_codes.create! name: '55555'

schmorbodia_bin_blue = schmorbodia.bins.create! name: 'blue', color: '#0000c8'
schmorbodia_bin_green = schmorbodia.bins.create! name: 'green', color: '#008000'

schmorbodia_bin_blue.add_items!([
  # Aluminum items
  { name: 'Aluminum soda cans', category: metal },
  { name: 'Aluminum beer cans', category: metal },
  { name: 'Fruit cans', category: metal },
  { name: 'Vegetable cans', category: metal },

  # Paper items
  { name: 'Junk mail', category: paper },
  { name: 'Telephone books', category: paper },
  { name: 'Cereal boxes', category: paper },
  { name: 'Tissue boxes', category: paper },
])

schmorbodia_bin_green.add_items! ([
  # Glass items
  { name: 'Juice bottles', category: glass },
  { name: 'Beer bottles', category: glass },

  # Plastic items
  { name: 'Plastic water bottles', category: plastic },
  { name: 'Plastic soda bottles', category: plastic }
])

# Add some real, empty cities, but not all of them (it takes way too long)
if ENV["NUM_CITIES"].nil?
  num_cities = 1000
elsif ENV["NUM_CITIES"].downcase == "inf"
  num_cities = Float::INFINITY
else
  num_cities = ENV["NUM_CITIES"].to_i
end

CSV.foreach Rails.root.join('sample-data', 'all-cities.csv'), headers: true do |row|
  eval_city_csv row
  break if City.count >= num_cities
end

# Create some test users
claremont.officials.create!(
  first_name: 'Harvey',
  middle_name: 'Daniel',
  last_name: 'Mudd',
  email: 'team.daniel.cs121@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)

Admin.create!(
  first_name: 'Louis',
  last_name: 'Spanias',
  email: 'team.daniel.cs121@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)

# Terms for the glossary. Selected terms and definitions take from
# http://www.rethinkrecycling.com/businesses/glossary
Term.create!([
  { name: 'biodegradable', definition:
    'Capable of being decomposed by organic processes into elements found in nature when under ' +
    'conditions that allow decomposition. The term may be used in marketing products, sometimes ' +
    'without relevance to whether available disposal methods will allow decomposition.'
  },
  { name: 'composting', definition:
    'The microbial process that breaks down organic waste into a humus-like soil amendment.'
  },
  { name: 'contamination', definition:
    'Inadequate sorting of recyclable materials that interferes with the clean processing of ' +
    'recyclables. For example, a single ceramic coffee mug can cause a ten-ton load of glass ' +
    'bottles to be rejected by the end market; or contamination of office paper can occur if ' +
    'food, carbon paper, metal cans - essentially, any non-paper item - is added to the load.'
  }
])

# A sample article
md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
Article.create!(
  title: 'About',
  content: md.render(File.read(Rails.root.join('..', 'README.md')))
)
