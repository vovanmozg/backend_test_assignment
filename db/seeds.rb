BRANDS_DATA = JSON.parse(File.read('db/brands.json'))
CARS_DATA = JSON.parse(File.read('db/cars.json'))

BRANDS = BRANDS_DATA.each.with_object({}) do |brand_item, memo|
  brand_name = brand_item['name']
  memo[brand_name] = Brand.create!(name: brand_name)
end

CARS_DATA.each do |car_item|
  Car.create!(
    model: car_item['model'],
    brand: BRANDS[car_item['brand_name']],
    price: car_item['price'],
  )
end

User.create!(
  email: 'example@mail.com',
  preferred_price_range: 35_000...40_000,
  preferred_brands: [BRANDS['Alfa Romeo'], BRANDS['Volkswagen']],
)
#
# # Brands
# 1000.times do
#   Brand.create!(
#     name: (0...10).map { ([' ']+('A'..'Z').to_a)[rand(26)] }.join
#   )
# end
#
# last_brand_id = Brand.maximum(:id)
#
# # Cars
# 1000000.times do |i|
#   print '.' if i % 100 == 0
#   Car.create!(
#     model: (0...10).map { ([' ']+('a'..'z').to_a)[rand(26)] }.join,
#     brand_id: rand(1..last_brand_id),
#     price: rand(1000..100000)
#   )
# end
