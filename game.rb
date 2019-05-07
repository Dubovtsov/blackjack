# frozen_string_literal: true

require_relative 'deck'
require_relative 'user'
require_relative 'hand'
require_relative 'bank'
require_relative 'interface'

class Game
  attr_accessor :current_deck, :bank, :dealer

  def initialize
    @current_deck = Deck.new
    @bank = Bank.new
    @dealer = User.new('Dealer', 100)
    # @action_menu = MENU
    @interface = Interface.new
  end

  def run
    @interface.system_clear
    name = @interface.user_input('Как Вас зовут?')
    @interface.message("Добро пожаловать в игру, #{name}!")
    initial_conditions(name)

    loop do
      choise = gets.chomp
      case choise
      when '1'
        @interface.system_clear
        move
      when '2'
        @interfacesystem_clear
        skip
      when '3'
        @interfacesystem_clear
        show
      when '4'
        @interfacesystem_clear
        again
        break if @quit == 'break'
      when '5'
        @interfacesystem_clear
        @interface.separator
        Game.new.run
      when '6'
        @interface.message('Будем рады видеть Вас снова!')
        break
      else
        @interface.message('Неверный ввод!')
      end
    end
  end

  def initial_conditions(name)
    @interface.separator
    @user = User.new(name, 100)
    user_move(2)
    @user.bet(@bank)
    dealer_move(2)
    @dealer.bet(@bank)
    main_info
    @interface.show_menu
  end

  def main_info
    @interface.show_account(@user.cash)
    @interface.show_account(@dealer.cash)
    message_bank
    show_cards
  end

  def dealer_move(num_of_cards)
    @dealer.take_card(num_of_cards, @current_deck)
  end

  def user_move(num_of_cards)
    @user.take_card(num_of_cards, @current_deck)
  end

  def move
    if !@user.hand.losing
      user_move(1)
      @interface.show_cards @user
      @interface.message_dealer_move
      @interface.loading
      if @dealer.hand.points < 17
        dealer_move(1)
        interface.show_cards @dealer
        @interface.show_menu
      else
        @interface.separator
        @interface.message_skip
        show_cards @dealer
        @interface.show_menu
      end
    else
      @interface.separator
      @interface.message('Достаточно!')
      @interface.message_dealer_move
      @interface.loading
      if @dealer.hand.points < 17
        dealer_move(1)
        show_cards
      else
        @interface.message_skip
        show_cards @dealer
      end
      @interface.show_menu
    end
  end

  def skip
    @interface.message_dealer_move
    @interface.loading
    if @dealer.hand.points < 17
      dealer_move(1)
      show_cards
      @interface.show_menu
    else
      @interface.separator
      @interface.message_skip
      show_cards
      @interface.show_menu
    end
  end

  def show
    @interface.message_cards @dealer
    @interface.separator
    @interface.withseparator(@dealer.cards_in_hand('show'))
    print "\n"

    @interface.message_cards @user
    @interface.separator
    @interface.withseparator(@user.cards_in_hand('show'))
    print "\n"

    if @user.hand.points > @dealer.hand.points && !@user.hand.losing ||
       !@user.hand.losing && @dealer.hand.losing
      @interface.message('Вы выиграли!')
      @bank.gain(@user)
      show_accounts
      @interface.message_bank
    elsif @user.hand.points == @dealer.hand.points && !@user.hand.losing
      @interface.message('Ничья!')
      @bank.return_bet(@user)
      @bank.return_bet(@dealer)
      @interface.message_bank
      show_accounts
    elsif @user.hand.points < @dealer.hand.points && !@dealer.hand.losing ||
          @user.hand.points > @dealer.hand.points && !@dealer.hand.losing
      @interface.message('Вы проиграли!')
      @bank.gain(@dealer)
      show_accounts
      @interface.message_bank
    else
      @interface.message('Перебор!')
      @bank.return_bet(@user)
      @bank.return_bet(@dealer)
      @interface.message_bank
      show_accounts
    end
    @interface.separator
    @interface.show_menu
  end

  def again
    if @user.cash >= 10 && @dealer.cash >= 10
      @current_deck = Deck.new
      @user.hand = Hand.new
      user_move(2)
      @user.bet(@bank)

      @dealer.hand = Hand.new
      dealer_move(2)
      @dealer.bet(@bank)

      @interface.main_info
      @interface.show_menu
    else
      @interface.message('Недостаточно средств для ставки. Игра окончена!')
      @quit = 'break'
    end
  end
end
