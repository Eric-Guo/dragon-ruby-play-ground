# frozen_string_literal: true

# Copyright 2021 Scratchwork Development LLC. All rights reserved.

PI = 3.1415926

require 'app/rect.rb'
require 'app/marker.rb'
require 'app/game.rb'
require 'app/game_defaults.rb'
require 'app/game_render.rb'
require 'app/game_input.rb'
require 'app/game_calc.rb'

def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end

$gtk.reset
