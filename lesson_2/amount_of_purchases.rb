puts 'Enter the name of the product'

product = gets.chomp

h = {}
while product != 'stop'
  puts 'Enter the price per unit of the item'
  price = gets.to_f
  puts 'Enter the quantity of the purchased item'
  quantity = gets.to_f
  h[product] = {}
  h[product][:price] = price
  h[product][:quantity] = quantity
  puts 'Enter the name of the product'
  product = gets.chomp
end

puts h

total_price = 0

h.each do |product_name, product_data|
  total_product_price = product_data[:price] * product_data[:quantity]
  puts "#{product_name}: #{total_product_price}$"
  total_price += total_product_price
end

puts "Total price: #{total_price}$"
