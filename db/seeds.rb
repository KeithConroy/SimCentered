Organization.create(title: "SimCentered University")
Organization.create(title: "SimCentered Nursing")
User.create(first_name: "Keith", last_name: "Conroy", email: "keith@mail.com", password: "123", organization_id: 1)

10.times do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    organization_id: 1
  )
end

10.times do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    organization_id: 2
  )
end

10.times do |num|
  Room.create(
    title: "Exam Room #{num + 1}",
    number: Faker::Number.number(3),
    building: Faker::Company.name,
    organization_id: 1
  )
end

10.times do |num|
  Room.create(
    title: "Exam Room #{num + 1}",
    number: Faker::Number.number(3),
    building: Faker::Company.name,
    organization_id: 2
  )
end

# Organization.create(
#   title: Faker::University.name
# )
