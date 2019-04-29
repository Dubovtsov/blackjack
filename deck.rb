require "deck_helper"

class Deck
  include DeckHelper

  def initialize
    deck = mix_deck
  end

  # метод рандомайзер
  def mix_deck
    deck = Spades.concat(Hearts, Clubs, Diamonds).shuffle
  end
end