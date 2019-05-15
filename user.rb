# frozen_string_literal: true

class User

  attr_reader :name
  attr_accessor :cash, :hand

  def initialize(name, cash)
    @name = name
    @cash = cash
    @hand = Hand.new
  end

  def take_card(n, deck)
    n.times do |_x|
      card = deck.cards.last
      sum = hand.scoring
      if card.points == 11 && sum + card.points > 21
        card.points = 1
        @hand.cards << card
        deck.cards.pop
      else
        @hand.cards << card
        deck.cards.pop
      end
    end
    @current_hand
  end

  def bet(bank, money)
    @cash -= money
    bank.bank_amount += money
  end
end
