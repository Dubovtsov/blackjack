require_relative "deck"
require_relative "user"

deck = Deck.new

puts deck.deck
puts "Как Вас зовут?"
name = gets.chomp
user = User.new(name, 100, take_cart(2))
puts user.hand
puts deck.deck
# нужен метод с аргументом, возвращающий карты

def take_cart(n)
  n.times do |value|
    current_hand = []
    current_hand << deck.deck.last
    deck.deck.pop!
  end
end