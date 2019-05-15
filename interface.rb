# frozen_string_literal: true

require_relative 'deck'
require_relative 'user'
require_relative 'bank'
require_relative 'game'

class Interface
  MENU = {
    1 => 'Взять карту',
    2 => 'Пропустить ход',
    3 => 'Показать карты',
    4 => 'Новая раздача',
    5 => 'Начать заново',
    6 => 'Выйти из игры'
  }.freeze

  attr_reader :menu

  def initialize
    @menu = MENU
  end

  def game
    loop do
      choise = gets.chomp
      case choise
      when '1'
        system_clear
        move
      when '2'
        system_clear
        skip
      when '3'
        system_clear
        show
      when '4'
        system_clear
        again
        break if @quit == 'break'
      when '5'
        system_clear
        Game.new.run
      when '6'
        message('Будем рады видеть Вас снова!')
        break
      else
        message('Неверный ввод!')
      end
      rescue StandardError => e
        puts e.message
        puts e.backtrace
    end
  end

  def loading
    3.times do
      sleep 0.5
      print ' - '
    end
    puts ''
  end

  def user_input(input)
    puts "#{input}:"
    gets.chomp
  end

  def system_clear
    system 'clear'
  end

  def separator
    puts '-------------------------------------------'
  end

  def message_cards(player)
    puts player.name == 'Dealer' ? 'Карты дилера:' : 'Ваши карты:'
  end

  def message(output)
    puts "🗩  #{output} 🗩"
  end

  def message_dealer_move
    puts '🗩  Ход дилера 🗩'
  end

  def message_skip
    puts '🗩  Дилер пропускает ход 🗩'
  end

  def message_bank(bank_amount)
    puts "🏛  Денег в банке: #{bank_amount}$"
  end

  def show_account(_message, _user_account)
    puts "#{_message} #{_user_account}$"
  end

  def withseparator(_method_name)
    _method_name
    print "\n"
    separator
  end

  # def show_cards(cards_in_hand)
  #   withseparator(cards_in_hand)
  # end

  def show_menu
    puts 'Выберите действие(введите цифру от 1 до 5):'
    @menu.each do |key, value|
      puts "#{key} 🖝  #{value}"
    end
  end

  def skip
    message_dealer_move
    loading
    if @dealer.hand.scoring < 17
      dealer_move(1)
      game_card_hands
      show_menu
    else
      separator
      message_skip
      game_card_hands
      show_menu
    end
  end

  def game_return
    @bank.return_bet(@user)
    @bank.return_bet(@dealer)
    message_bank(@bank.bank_amount)
    show_account('На вашем счёте:', @user.cash)
    show_account('Счёт Дилера:', @dealer.cash)
  end

  def game_output_info
    message_cards(@dealer)
    separator
    withseparator(cards_in_hand(@dealer, 'show'))
    print "\n"

    message_cards(@user)
    separator
    withseparator(cards_in_hand(@user, 'show'))
    print "\n"
  end

  def start_game(deck, bank, dealer)
    @current_deck = deck
    @bank = bank
    @dealer = dealer
    name = user_input('Как Вас зовут?')
    message("Добро пожаловать в игру, #{name}!")
    initial_conditions(name)
  end

  def initial_conditions(name)
    @user = User.new(name, 100)
    user_move(2)
    @user.bet(@bank, 10)
    dealer_move(2)
    @dealer.bet(@bank, 10)
    main_info
    game_card_hands
    withseparator show_menu
  end


  def cards_in_hand(player, show = nil)
    player.hand.cards.each do |card, _index|
      if show.nil?
        print ' | * | '
      else
        print "| #{card.name}#{card.suit} | "
      end
    end
    print "сумма очков: #{player.hand.scoring}" unless show.nil?
  end


  def game_card_hands
    puts 'У Вас в руке:'
    separator
    withseparator(cards_in_hand(@user, 'show'))
    puts 'В руке Дилера:'
    separator
    withseparator(cards_in_hand(@dealer))
  end

  def move
    if !@user.hand.losing
      withseparator user_move(1)
      withseparator cards_in_hand(@user, 'show')
      message_dealer_move
      withseparator loading
      if @dealer.hand.scoring < 17
        dealer_move(1)
        withseparator cards_in_hand(@dealer)
        show_menu
      else
        message_skip
        withseparator cards_in_hand(@dealer)
        show_menu
      end
    else
      message('Достаточно!')
      message_dealer_move
      loading
      if @dealer.hand.scoring < 17
        dealer_move(1)
        game_card_hands
      else
        message_skip
        withseparator(cards_in_hand(@dealer))
      end
      show_menu
    end
  end

  def main_info
    show_account('На вашем счёте:', @user.cash)
    show_account('Счёт Дилера:', @dealer.cash)
    message_bank(@bank.bank_amount)
  end

  def show
    game_output_info
    if @user.hand.scoring > @dealer.hand.scoring && !@user.hand.losing ||
       !@user.hand.losing && @dealer.hand.losing
      message('Вы выиграли!')
      @bank.gain(@user)
      main_info
    elsif @user.hand.scoring == @dealer.hand.scoring && !@user.hand.losing
      message('Ничья!')
      game_return
    elsif @user.hand.scoring < @dealer.hand.scoring && !@dealer.hand.losing ||
          @user.hand.scoring > @dealer.hand.scoring && !@dealer.hand.losing
      message('Вы проиграли!')
      @bank.gain(@dealer)
      main_info
    else
      message('Перебор!')
      game_return
    end
    separator
    show_menu
  end


  def dealer_move(num_of_cards)
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
      main_info
      game_card_hands
      show_menu
    else
      message('Недостаточно средств для ставки. Игра окончена!')
      @quit = 'break'
    end
  end
end
