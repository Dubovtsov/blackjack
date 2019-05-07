# frozen_string_literal: true

class Card
  attr_reader :spades, :hearts, :diamonds, :clubs

  @nominal_value = (2..11).to_a

  @card_suits = [
    '♠', '♥', '♦', '♣'
  ]

  def deck_generator
    @deck = []
    @card_suits.each do |_suit|
      @nominal_value.each do |_value|
        @deck << { name: _suit, number: _value }
      end
    end
  end

  SPADES = [
    { name: '2♠', number: 2 },
    { name: '3♠', number: 3 },
    { name: '4♠', number: 4 },
    { name: '5♠', number: 5 },
    { name: '6♠', number: 6 },
    { name: '7♠', number: 7 },
    { name: '8♠', number: 8 },
    { name: '9♠', number: 9 },
    { name: '10♠', number: 10 },
    { name: 'J♠', number: 10 },
    { name: 'Q♠', number: 10 },
    { name: 'K♠', number: 10 },
    { name: 'T♠', number: 11 }
  ]
  HEARTS = [
    { name: '2♥', number: 2 },
    { name: '3♥', number: 3 },
    { name: '4♥', number: 4 },
    { name: '5♥', number: 5 },
    { name: '6♥', number: 6 },
    { name: '7♥', number: 7 },
    { name: '8♥', number: 8 },
    { name: '9♥', number: 9 },
    { name: '10♥', number: 10 },
    { name: 'J♥', number: 10 },
    { name: 'Q♥', number: 10 },
    { name: 'K♥', number: 10 },
    { name: 'T♥', number: 11 }
  ]
  DIAMONDS = [
    { name: '2♦', number: 2 },
    { name: '3♦', number: 3 },
    { name: '4♦', number: 4 },
    { name: '5♦', number: 5 },
    { name: '6♦', number: 6 },
    { name: '7♦', number: 7 },
    { name: '8♦', number: 8 },
    { name: '9♦', number: 9 },
    { name: '10♦', number: 10 },
    { name: 'J♦', number: 10 },
    { name: 'Q♦', number: 10 },
    { name: 'K♦', number: 10 },
    { name: 'T♦', number: 11 }
  ]
  CLUBS = [
    { name: '2♣', number: 2 },
    { name: '3♣', number: 3 },
    { name: '4♣', number: 4 },
    { name: '5♣', number: 5 },
    { name: '6♣', number: 6 },
    { name: '7♣', number: 7 },
    { name: '8♣', number: 8 },
    { name: '9♣', number: 9 },
    { name: '10♣', number: 10 },
    { name: 'J♣', number: 10 },
    { name: 'Q♣', number: 10 },
    { name: 'K♣', number: 10 },
    { name: 'T♣', number: 11 }
  ]

  def initialize
    @spades = SPADES
    @hearts = HEARTS
    @diamonds = DIAMONDS
    @clubs = CLUBS
  end
end
