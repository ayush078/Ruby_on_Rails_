# Clear existing data
Rating.destroy_all
Store.destroy_all
User.destroy_all

# Create System Admin
admin = User.create!(
  name: "System Administrator Account",
  email: "admin@storerating.com",
  password: "Admin123!",
  password_confirmation: "Admin123!",
  address: "123 Admin Street, Admin City, Admin State 12345",
  role: "system_admin"
)

puts "Created System Admin: #{admin.email}"

# Create Store Owners
store_owner1 = User.create!(
  name: "John Smith Store Owner Account",
  email: "john@techstore.com",
  password: "Owner123!",
  password_confirmation: "Owner123!",
  address: "456 Business Avenue, Commerce City, Business State 67890",
  role: "store_owner"
)

store_owner2 = User.create!(
  name: "Sarah Johnson Store Owner Account",
  email: "sarah@bookstore.com",
  password: "Owner456!",
  password_confirmation: "Owner456!",
  address: "789 Book Lane, Literature Town, Reading State 11111",
  role: "store_owner"
)

store_owner3 = User.create!(
  name: "Michael Brown Store Owner Account",
  email: "michael@foodstore.com",
  password: "Owner789!",
  password_confirmation: "Owner789!",
  address: "321 Food Street, Culinary City, Taste State 22222",
  role: "store_owner"
)

puts "Created Store Owners: #{store_owner1.email}, #{store_owner2.email}, #{store_owner3.email}"

# Create Stores
tech_store = Store.create!(
  name: "Tech Electronics Store Chain",
  email: "contact@techstore.com",
  address: "456 Business Avenue, Commerce City, Business State 67890",
  user: store_owner1
)

book_store = Store.create!(
  name: "Classic Books and Literature Store",
  email: "info@bookstore.com",
  address: "789 Book Lane, Literature Town, Reading State 11111",
  user: store_owner2
)

food_store = Store.create!(
  name: "Gourmet Food and Grocery Store",
  email: "hello@foodstore.com",
  address: "321 Food Street, Culinary City, Taste State 22222",
  user: store_owner3
)

puts "Created Stores: #{tech_store.name}, #{book_store.name}, #{food_store.name}"

# Create Normal Users
normal_users = []
5.times do |i|
  user = User.create!(
    name: "Normal User Account Number #{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "User123!",
    password_confirmation: "User123!",
    address: "#{100 + i} User Street, User City, User State #{10000 + i}",
    role: "normal_user"
  )
  normal_users << user
end

puts "Created #{normal_users.count} Normal Users"

# Create Ratings
stores = [tech_store, book_store, food_store]
rating_values = [1, 2, 3, 4, 5]

normal_users.each do |user|
  # Each user rates 2-3 stores randomly
  stores.sample(rand(2..3)).each do |store|
    Rating.create!(
      user: user,
      store: store,
      rating: rating_values.sample
    )
  end
end

puts "Created #{Rating.count} Ratings"

# Display summary
puts "\n=== SEED DATA SUMMARY ==="
puts "Total Users: #{User.count}"
puts "- System Admins: #{User.admins.count}"
puts "- Store Owners: #{User.store_owners.count}"
puts "- Normal Users: #{User.normal_users.count}"
puts "Total Stores: #{Store.count}"
puts "Total Ratings: #{Rating.count}"

puts "\n=== LOGIN CREDENTIALS ==="
puts "System Admin: admin@storerating.com / Admin123!"
puts "Store Owner 1: john@techstore.com / Owner123!"
puts "Store Owner 2: sarah@bookstore.com / Owner456!"
puts "Store Owner 3: michael@foodstore.com / Owner789!"
puts "Normal User 1: user1@example.com / User123!"
puts "Normal User 2: user2@example.com / User123!"
puts "Normal User 3: user3@example.com / User123!"
puts "Normal User 4: user4@example.com / User123!"
puts "Normal User 5: user5@example.com / User123!"

puts "\nSeed data created successfully!"

