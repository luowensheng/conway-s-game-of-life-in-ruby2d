require_relative "game.rb"


game = GameOfLife::Game.new

update do
    clear
    game.draw_lines
    game.draw_alive_squares
end

on :mouse_down do |event|
    game.manual_draw(event.x, event.y)
end


on :key_down do |event|
    game.process_input(event.key)
end

show

