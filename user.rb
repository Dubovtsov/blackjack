# frozen_string_literal: true

class User
  attr_accessor :name, :cash, :hand
  def initialize(name, cash = 100, hand = [])
    @name = name
    @cash = cash
    @hand = hand
  end

  def take_card(n, deck)
    n.times do |x|
      @hand << deck.deck.last
      deck.deck.pop
    end
    @current_hand
  end
end
