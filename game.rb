# frozen_string_literal: true

require_relative 'deck'
require_relative 'user'
require_relative 'bank'
require_relative 'interface'

class Game
  include Interface
  attr_accessor :current_deck, :bank, :dealer

  def initialize
    @current_deck = Deck.new
    @bank = Bank.new
    @dealer = User.new('Dealer', 100)
    @action_menu = MENU
  end

  def run
    system 'clear'
    name = user_input('Как Вас зовут?')
    message("Добро пожаловать в игру, #{name}!")
    initial_conditions(name)

    loop do
      choise = gets.chomp
      case choise
      when '1'
        system 'clear'
        move
      when '2'
        system 'clear'
        skip
      when '3'
        system 'clear'
        show
      when '4'
        system 'clear'
        again
        break if @quit == 'break'
      when '5'
        system 'clear'
        separator
        Game.new(MENU).run
      when '6'
        message('Будем рады видеть Вас снова!')
        break
      else
        message('Неверный ввод!')
      end
    end
  end

  def initial_conditions(name)
    separator
    @user = User.new(name, 100)
    user_move(2)
    @user.bet(@bank)
    dealer_move(2)
    @dealer.bet(@bank)
    main_info
    show_menu
  end

  def dealer_move(num_of_cards)
    @dealer.take_card(num_of_cards, @current_deck)
  end

  def user_move(num_of_cards)
    @user.take_card(num_of_cards, @current_deck)
  end

  def move
    if @user.points < 20
      user_move(1)
      show_cards @user
      message_dealer_move
      loading
      if @dealer.points < 17
        dealer_move(1)
        show_cards @dealer
        show_menu
      else
        separator
        message_skip
        show_cards @dealer
        show_menu
      end
    else
      separator
      message('Достаточно!')
      message_dealer_move
      loading
      if @dealer.points < 17
        dealer_move(1)
        show_cards
      else
        message_skip
        show_cards @dealer
      end
      show_menu
    end
  end

  def skip
    message_dealer_move
    loading
    if @dealer.points < 17
      dealer_move(1)
      show_cards
      show_menu
    else
      separator
      message_skip
      show_cards
      show_menu
    end
  end

  def show
    puts 'Карты дилера:'
    separator
    withseparator(@dealer.cards_in_hand('show'))
    print "\n"

    puts 'Ваши карты:'
    separator
    withseparator(@user.cards_in_hand('show'))
    print "\n"

    if @user.points > @dealer.points && @user.points <= 21 ||
       @user.points <= 21 && @dealer.points > 21
      message('Вы выиграли!')
      @bank.gain(@user)
      show_accounts
      message_bank
    elsif @user.points == @dealer.points && @user.points <= 21
      message('Ничья!')
      @bank.return_bet(@user)
      @bank.return_bet(@dealer)
      message_bank
      show_accounts
    elsif @user.points < @dealer.points && @dealer.points <= 21 ||
          @user.points > @dealer.points && @dealer.points <= 21
      message('Вы проиграли!')
      @bank.gain(@dealer)
      show_accounts
      message_bank
    else
      message('Перебор!')
      @bank.return_bet(@user)
      @bank.return_bet(@dealer)
      message_bank
      show_accounts
    end
    separator
    show_menu
  end

  def again
    if @user.cash >= 10 && @dealer.cash >= 10
      @current_deck = Deck.new
      @user.hand = []
      user_move(2)
      @user.bet(@bank)

      @dealer.hand = []
      dealer_move(2)
      @dealer.bet(@bank)

      main_info
      show_menu
    else
      message('Недостаточно средств для ставки. Игра окончена!')
      @quit = 'break'
    end
  end
end
