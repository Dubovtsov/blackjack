# frozen_string_literal: true

class Card
  attr_reader :suit, :name, :points

  def initialize(suit, points, name)
    @suit = suit
    @points = points
    @name = name
  end
end
