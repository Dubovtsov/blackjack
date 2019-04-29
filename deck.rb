require_relative "deck_helper"

class Deck
  include DeckHelper
  attr_reader :deck
  def initialize
    @deck = []
    @deck = Deck.mix_deck
  end

  # метод рандомайзер
  def self.mix_deck
    Spades.concat(Hearts, Clubs, Diamonds).shuffle
  end
end

# For testing
# d = Deck.new
# puts d.deck