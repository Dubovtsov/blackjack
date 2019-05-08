# frozen_string_literal: true

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    generate
  end

  def generate
    %w[♠ ♥ ♦ ♣].each do |suit|
      (2..10).each { |points| @cards << Card.new(suit, points, points.to_s) }
      %w[K Q J].each { |name| @cards << Card.new(suit, 10, name) }
      @cards << Card.new(suit, 11, 'A')
    end
    @cards.shuffle!
  end
end
