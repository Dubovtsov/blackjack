# frozen_string_literal: true

class User
  attr_reader :name
  attr_accessor :cash, :hand

  def initialize(name, cash = 100, hand = [])
    @name = name
    @cash = cash
    @hand = Hand.new
  end

  def take_card(n, deck)
    n.times do |_x|
      card = deck.deck.last
      sum = hand.points
      if card[:number] == 11 && sum + card[:number] > 21
        card[:number] = 1
        @hand << card
        deck.deck.pop
      else
        @hand.hand << card
        deck.deck.pop
      end
    end
    @current_hand
  end

  def cards_in_hand(show = nil)
    hand.hand.each do |card, _index|
      if show.nil?
        print ' | * | '
      else
        print "| #{card[:name]} | "
      end
    end
    print "сумма очков: #{hand.points}" unless show.nil?
  end

  def bet(bank, money = 10)
    @cash -= money
    bank.bank_amount += money
  end
end
