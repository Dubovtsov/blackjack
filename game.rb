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
    initial_conditions (@interface.start_game)
    @interface.main_info(@user, @dealer, @bank)
    @interface.game_cards_hands(@user, @dealer)
    @interface.show_menu
    loop do
      choise = gets.chomp
      case choise
      when '1'
        move
      when '2'
        skip
      when '3'
        @interface.show(@user, @dealer, @bank)
      when '4'
        again
        break if @quit == 'break'
      when '5'
        Game.new.run
      when '6'
        @interface.message('Будем рады видеть Вас снова!')
        break
      else
        @interface.message('Неверный ввод!')
      end
      rescue StandardError => e
        puts e.message
        puts e.backtrace
    end
  end

  private

  def initial_conditions(name)
    @user = User.new(name, 100)
    user_move(2)
    @user.bet(@bank, 10)
    dealer_move(2)
    @dealer.bet(@bank, 10)
  end

  def move
    if !@user.hand.losing
      user_move(1)
      @interface.cards_in_hand(@user, 'show')
      if @dealer.hand.scoring < 17
        dealer_move(1)
        @interface.cards_in_hand(@dealer)
      else
        @interface.message_skip
        @interface.cards_in_hand(@dealer)
      end
    else
      @interface.message('Достаточно!')
      if @dealer.hand.scoring < 17
        dealer_move(1)
        @interface.game_card_hands
      else
        @interface.message_skip
        cards_in_hand(@dealer)
      end
    end
    @interface.show_menu
  end

  def skip
    if @dealer.hand.scoring < 17
      dealer_move(1)
      @interface.game_cards_hands(@user, @dealer)
    else
      @interface.message_skip
      @interface.game_cards_hands(@user, @dealer)
    end
    @interface.show_menu
  end

  def dealer_move(num_of_cards)
    @interface.message_dealer_move
    @interface.loading
    @dealer.take_card(num_of_cards, @current_deck)
  end

  def user_move(num_of_cards)
    @user.take_card(num_of_cards, @current_deck)
  end

  def again
    if @user.cash >= 10 && @dealer.cash >= 10
      @current_deck = Deck.new
      @user.hand = Hand.new
      user_move(2)
      @user.bet(@bank, 10)
      @dealer.hand = Hand.new
      dealer_move(2)
      @dealer.bet(@bank, 10)
      @interface.main_info(@user, @dealer, @bank)
      @interface.game_cards_hands(@user, @dealer)
      @interface.show_menu
    else
      @interface.message('Недостаточно средств для ставки. Игра окончена!')
      @quit = 'break'
    end
  end
end
