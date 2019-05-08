@nominal_value =
[2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6,
 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10,
 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11]

@card_suits = [
  '♠', '♥', '♦', '♣'
]

# def deck_generator
#   @deck = []
#   @deck_full = []
#   # @deck = '2,3,4,5,6,7,8,9,10,10,10,11'.split(',').zip('23456789JQKA'.split('')).to_h
#   '2,3,4,5,6,7,8,9,10,J,Q,K,A'.split(',').product('♠♥♦♣'.split('')) do |el|
#     @deck << el.join
#   end
#   # @deck.each do |e|
#   #   @nominal_value.each do |value|
#   #     @deck_full << { number: value, name: e }
#   #   end
#   # end
#   @deck.zip(@nominal_value) {|x| }
#   # @deck.zip(@nominal_value).to_h
# end

# # [2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6,
# #  7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10,
# #  10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11]
# # @@deck.each do |value|
# #   4.times do |_x|

# #   end
# end
def generate
    @card_suits.each do |suit|
      (2..10).each { |points| @cards << Card.new(suit, points, points.to_s) }
      %w[K Q J].each { |face| @cards << Card.new(suit, 10, face) }
      cards << Card.new(suit, [1, 11], 'A')
    end
  end