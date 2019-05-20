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

  def show_account(message, user_account)
    puts "#{message} #{user_account}$"
  end

  def withseparator(method_name)
    method_name
    print "\n"
    separator
  end

  def show_menu
    puts 'Выберите действие(введите цифру от 1 до 5):'
    @menu.each do |key, value|
      puts "#{key} 🖝  #{value}"
    end
  end

  def game_return(user, dealer, bank)
    bank.return_bet(user)
    bank.return_bet(dealer)
    main_info(user, dealer, bank)
  end

  def game_output_info(user, dealer)
    message_cards(dealer)
    separator
    withseparator cards_in_hand(dealer, 'show')
    print "\n"

    message_cards(user)
    separator
    withseparator cards_in_hand(user, 'show')
    print "\n"
  end

  def start_game
    name = user_input('Как Вас зовут?')
    message("Добро пожаловать в игру, #{name}!")
    name
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


  def game_cards_hands(user, dealer)
    puts 'У Вас в руке:'
    separator
    withseparator cards_in_hand(user, 'show')
    puts 'В руке Дилера:'
    separator
    withseparator cards_in_hand(dealer)
  end

  def main_info(user, dealer, bank)
    show_account('На вашем счёте:', user.cash)
    show_account('Счёт Дилера:', dealer.cash)
    message_bank(bank.bank_amount)
  end

  def show(user, dealer, bank)
    game_output_info(user, dealer)
    if user.hand.scoring > dealer.hand.scoring && !user.hand.losing ||
       !user.hand.losing && dealer.hand.losing
      message('Вы выиграли!')
      bank.gain(user)
      main_info(user, dealer, bank)
    elsif user.hand.scoring == dealer.hand.scoring && !user.hand.losing
      message('Ничья!')
      game_return(user, dealer, bank)
    elsif user.hand.scoring < dealer.hand.scoring && !dealer.hand.losing ||
          user.hand.scoring > dealer.hand.scoring && !dealer.hand.losing
      message('Вы проиграли!')
      bank.gain(dealer)
      main_info(user, dealer, bank)
    else
      message('Перебор!')
      game_return(user, dealer, bank)
    end
    separator
    show_menu
  end
end
