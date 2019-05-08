class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def scoring
    sum = 0
    cards.each do |card|
      sum += card.points
      # puts card
    end
    sum
  end

  def losing
    scoring > 21
  end
end
