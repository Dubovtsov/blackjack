# frozen_string_literal: true

require_relative 'deck_helper'

class Deck
  include DeckHelper

  attr_reader :deck

  def initialize
    @deck = SPADES.concat(HEARTS, CLUBS, DIAMONDS).shuffle
  end
end
