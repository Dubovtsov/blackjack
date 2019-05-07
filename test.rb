@nominal_value = (2..11).to_a

@card_suits = [
  '♠', '♥', '♦', '♣'
]

def deck_generator
  @deck = []
  '23456789TJQKA'.split('').product('♠♥♦♣'.split('')) { |el| @deck << { name: el.join } }
  @deck
end
