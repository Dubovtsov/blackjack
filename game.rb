# frozen_string_literal: true

require_relative 'deck'
require_relative 'card'
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
        @interface.system_clear
        skip
      when '3'
        @interface.system_clear
        show
      when '4'
        @interface.system_clear
        again
        break if @quit == 'break'
      when '5'
        @interface.system_clear
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
    @interface.show_account('На вашем счёте:', @user.cash)
    @interface.show_account('Счёт Дилера:', @dealer.cash)
    @interface.message_bank(@bank.bank_amount)
    game_card_hands
  end

  def game_card_hands
    puts 'У Вас в руке:'
    @interface.separator
    @interface.show_cards(@user.cards_in_hand('show'))
    puts 'В руке Дилера:'
    @interface.separator
    @interface.show_cards(@dealer.cards_in_hand)
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
      @interface.show_cards(@user.cards_in_hand('show'))
      @interface.message_dealer_move
      @interface.loading
      if @dealer.hand.scoring < 17
        dealer_move(1)
        @interface.show_cards(@dealer.cards_in_hand)
        @interface.show_menu
      else
        @interface.separator
        @interface.message_skip
        @interface.show_cards(@dealer.cards_in_hand)
        @interface.show_menu
      end
    else
      @interface.separator
      @interface.message('Достаточно!')
      @interface.message_dealer_move
      @interface.loading
      if @dealer.hand.scoring < 17
        dealer_move(1)
        game_card_hands
      else
        @interface.message_skip
        @interface.show_cards(@dealer.cards_in_hand)
      end
      @interface.show_menu
    end
  end

  def skip
    @interface.message_dealer_move
    @interface.loading
    if @dealer.hand.scoring < 17
      dealer_move(1)
      game_card_hands
      @interface.show_menu
    else
      @interface.separator
      @interface.message_skip
      game_card_hands
      @interface.show_menu
    end
  end

  def show
    game_output_info
    if @user.hand.scoring > @dealer.hand.scoring && !@user.hand.losing ||
       !@user.hand.losing && @dealer.hand.losing
      @interface.message('Вы выиграли!')
      @bank.gain(@user)
      @interface.show_account('На вашем счёте:', @user.cash)
      @interface.show_account('Счёт Дилера:', @dealer.cash)
      @interface.message_bank(@bank.bank_amount)
    elsif @user.hand.scoring == @dealer.hand.scoring && !@user.hand.losing
      @interface.message('Ничья!')
      game_return
    elsif @user.hand.scoring < @dealer.hand.scoring && !@dealer.hand.losing ||
          @user.hand.scoring > @dealer.hand.scoring && !@dealer.hand.losing
      @interface.message('Вы проиграли!')
      @bank.gain(@dealer)
      @interface.show_account('На вашем счёте:', @user.cash)
      @interface.show_account('Счёт Дилера:', @dealer.cash)
      @interface.message_bank(@bank.bank_amount)
    else
      @interface.message('Перебор!')
      game_return
    end
    @interface.separator
    @interface.show_menu
  end

  def game_output_info
    @interface.message_cards(@dealer)
    @interface.separator
    @interface.withseparator(@dealer.cards_in_hand('show'))
    print "\n"

    @interface.message_cards(@user)
    @interface.separator
    @interface.withseparator(@user.cards_in_hand('show'))
    print "\n"
  end

  def game_return
    @bank.return_bet(@user)
    @bank.return_bet(@dealer)
    @interface.message_bank(@bank.bank_amount)
    @interface.show_account('На вашем счёте:', @user.cash)
    @interface.show_account('Счёт Дилера:', @dealer.cash)
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

      main_info
      @interface.show_menu
    else
      @interface.message('Недостаточно средств для ставки. Игра окончена!')
      @quit = 'break'
    end
  end
end
