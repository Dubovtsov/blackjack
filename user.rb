# frozen_string_literal: true

class User
  attr_reader :name
  attr_accessor :cash, :hand

  def initialize(name, cash = 100)
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
        @hand << card
        cards.pop
      else
        @hand.cards << card
        deck.cards.pop
      end
    end
    @current_hand
  end

  def cards_in_hand(show = nil)
    @hand.cards.each do |card, _index|
      if show.nil?
        print ' | * | '
      else
        print "| #{card.name}#{card.suit} | "
      end
    end
    print "сумма очков: #{@hand.scoring}" unless show.nil?
  end

  def bet(bank, money = 10)
    @cash -= money
    bank.bank_amount += money
  end
end
