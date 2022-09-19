require "test/unit"
require_relative "game.rb"


class TestGameOfLife < Test::Unit::TestCase

    def setup
       @game = GameOfLife::Game.new
    end

    def test_dead_cells

        assert_equal( :dead, @game.update_dead_cell( n_neighbors: 0) ) 
        assert_equal( :dead, @game.update_dead_cell( n_neighbors: 1) ) 
        assert_equal( :dead, @game.update_dead_cell( n_neighbors: 2) ) 
        assert_equal( :alive, @game.update_dead_cell( n_neighbors: 3) ) 
        assert_equal( :dead, @game.update_dead_cell( n_neighbors: 4) ) 
    end

    def test_live_cells

        assert_equal( :dead, @game.update_live_cell( n_neighbors: 0) ) 
        assert_equal( :dead, @game.update_live_cell( n_neighbors: 1) ) 
        assert_equal( :alive, @game.update_live_cell( n_neighbors: 2) ) 
        assert_equal( :alive, @game.update_live_cell( n_neighbors: 3) ) 
        assert_equal( :dead, @game.update_live_cell( n_neighbors: 4) )        
    end

    def test_neighbors
        
        @game.reset

        @game.grid[[0, 1]] = :alive
        @game.grid[[1, 1]] = :alive
        @game.grid[[0, 0]] = :alive

        assert_equal( 2, @game.get_number_of_live_neighbors(0,0) )
      
    end
end

