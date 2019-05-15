# frozen_string_literal: true

require_relative 'deck'
require_relative 'card'
require_relative 'user'
require_relative 'hand'
require_relative 'bank'
require_relative 'interface'

class Game
  INITIAL_ACCOUNT = 100

  attr_accessor :current_deck, :bank, :dealer

  def initialize
    @current_deck = Deck.new
    @bank = Bank.new
    @dealer = User.new('Dealer', INITIAL_ACCOUNT)
    @interface = Interface.new
  end

  def run
    @interface.start_game(@current_deck, @bank, @dealer)
    @interface.game
  end
end
