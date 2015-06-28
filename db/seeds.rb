# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create([
  {name: "Gry Akcji", short_name: "Akcja"},
  {name: "Strzelanie", short_name: "Strzelanie"},
  {name: "Gry Przygodowe", short_name: "Przygoda"},
  {name: "Gry Arcade", short_name: "Arcade"},
  {name: "Fizyka", short_name: "Fizyka"},
  {name: "Gry dla dzieci", short_name: "Dzieci"},
  {name: "Gotowanie", short_name: "Gotowanie"},
  {name: "Gry ze zwierzetami", short_name: "Zwierzęta"},
  {name: "Gry planszowe i karciane", short_name: "Planszowe i karciane"},
  {name: "Gry sportowe", short_name: "Sport"},
  {name: "Gry wyścigowe", short_name: "Wyścigi"},
  {name: "Multiplayery", short_name: "Multiplayer"},
  {name: "Gry dla dziewczynek", short_name: "Dla dziewczynek"},
  {name: "Quizy", short_name: "Quiz"},
	])