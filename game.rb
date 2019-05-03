require_relative 'deck'
require_relative 'user'
require_relative 'bank'
require_relative 'interface'

class Game
  include Interface
  attr_accessor :current_deck

  def initialize
    @current_deck = Deck.new
    @action_menu = {
      1 => 'Взять карту',
      2 => 'Пропустить ход',
      3 => 'Показать карты',
      4 => 'Новая раздача',
      5 => 'Начать заново',
      6 => 'Выйти из игры'
    }
  end

  def run
    system 'clear'
    name = user_input('Как Вас зовут?')
    puts "Добро пожаловать в игру, #{name}!"
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
        Game.new.run
      when '6'
        puts 'Будем рады видеть Вас снова!'
        break
      else
        puts 'Неверный ввод!'
      end
    end
  end

  def initial_conditions(name)
    separator
    @bank = Bank.new
    @user = User.new(name, 100)
    user_move(2)
    @user.bet(@bank)
    @dealer = User.new('Dealer', 100)
    dealer_move(2)
    @dealer.bet(@bank)
    main_info
    show_menu
  end

  def cards_in_hand(user, show_dealer = nil)
    sum = 0
    user.hand.each do |card, _index|
      if show_dealer.nil?
        print user == @user ? "| #{card[:name]} | " : '| * |'
      else
        print "| #{card[:name]} | "
      end
      sum += card[:number] if user == @user
      sum += card[:number] unless show_dealer.nil?
    end
    print "сумма очков: #{sum}" if user == @user
    print "сумма очков: #{sum}" unless show_dealer.nil?
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
      show_cards(@user)
      message_dealer_move
      loading
      if @dealer.points < 17
        dealer_move(1)
        show_cards(@dealer)
        show_menu
      else
        separator
        message_skip
        show_cards @dealer
        show_menu
      end
    else
      separator
      puts '🗩  Достаточно! 🗩'
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
    withseparator(cards_in_hand(@dealer, 'show'))
    print "\n"

    puts 'Ваши карты:'
    separator
    withseparator(cards_in_hand(@user))
    print "\n"

    if @user.points > @dealer.points && @user.points <= 21 ||
       @user.points <= 21 && @dealer.points > 21
      puts '🗩  Вы выиграли! 🗩'
      @bank.gain(@user)
      show_accounts
      message_bank
    elsif @user.points == @dealer.points && @user.points <= 21
      puts '🗩  Ничья! 🗩'
      @user.cash += 10
      @dealer.cash += 10
      @bank.bank_amount = 0
      message_bank
      show_accounts
    elsif @user.points < @dealer.points && @dealer.points <= 21 ||
          @user.points > @dealer.points && @dealer.points <= 21
      puts '🗩  Вы проиграли! 🗩'
      @bank.gain(@dealer)
      show_accounts
      message_bank
    else
      puts '🗩  Перебор! 🗩'
      @user.cash += 10
      @dealer.cash += 10
      @bank.bank_amount = 0
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
      puts 'Недостаточно средств для ставки. Игра окончена!'
      @quit = 'break'
    end
  end
end