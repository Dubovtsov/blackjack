# frozen_string_literal: true

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
  { name: 'T♠', number: 10 }
].freeze

# червы
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
  { name: 'T♥', number: 10 }
].freeze

# бубны
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
  { name: 'T♦', number: 10 }
].freeze

# трефы
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
  { name: 'T♣', number: 10 }
].freeze

# метод рандомайзер
def mix_deck
  deck = SPADES.concat(HEARTS, CLUBS, DIAMONDS).shuffle
end

puts mix_deck
