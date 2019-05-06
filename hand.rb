class Hand
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def points
    sum = 0
    hand.each do |card, _index|
      sum += card[:number]
    end
    sum
  end

  def losing
    points > 21
  end
end
