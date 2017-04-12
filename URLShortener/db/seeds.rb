# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(email: "user1@email.com")
user2 = User.create(email: "user2@email.com")
user3 = User.create(email: "user3@email.com")

short1 = ShortenedUrl.shorten_url(user1, "google.com")
short2 = ShortenedUrl.shorten_url(user2, "google.com")

visit1 = Visit.record_visit!(user2, short1)
visit2 = Visit.record_visit!(user1, short2)
