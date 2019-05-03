# frozen_string_literal: true
require_relative "card"

class Deck
  attr_reader :deck

  def initialize
    cards = Card.new
    @deck = cards.spades.concat(cards.hearts, cards.clubs, cards.diamonds).shuffle
  end
end
