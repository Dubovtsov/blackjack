# frozen_string_literal: true

require_relative 'game'
require_relative 'deck'
require_relative 'interface'
require_relative 'user'
require_relative 'bank'

include Interface

Game.new(MENU).run
