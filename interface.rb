require_relative "deck"
require_relative "user"

deck = Deck.new
puts deck.deck
puts "Как Вас зовут?"
name = gets.chomp
user = User.new(name, 100, deck.deck.last)
puts user.hand