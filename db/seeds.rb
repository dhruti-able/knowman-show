# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create([{
    name: 'admin',
    email: 'admin@knowmanshow.com',
    password: 'password',
    admin: true,
}, {
    name: 'public',
    email: 'public@knowmanshow.com',
    password: 'password',
    admin: false,
}])

halls = Hall.create([{
    name: 'hall-1',
    description: 'hall-1 total capacity 250',
    capacity: 250,
}])

shows = Show.create([{
    name: 'show-1',
    description: 'show-1 at hall-1',
    start_time: DateTime.now.change({hour: 18, min: 0, sec: 0}),
    end_time: DateTime.now.change({hour: 20, min: 0, sec: 0}),
    hall: halls.first,
}])