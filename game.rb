require 'ruby2d'

set background: 'white'

SIZE = 40
SQUARE_SIZE = 40
WIDTH = 20
HEIGHT = 20
set width: SIZE * WIDTH
set height: SIZE * HEIGHT



module GameOfLife

    class Game
        
        attr_reader :grid 

        def initialize

            @colors = { 2 => "blue", 3 => "purple"}

            @counter = 1
            @refresh_rate = 10
            
            @grid = {}

            @playing = true

            self.reset


        end

        def reset
            self.each_squares { |x, y| @grid[[x,y]] = :dead }
        end

        def randomize_board

            self.each_squares do |x, y|

                if rand()<0.30
                @grid[[x,y]] = :alive 

                else   
                @grid[[x,y]] = :dead

                end 

            end

        end
        
        def each_squares

            (Window.width/SQUARE_SIZE).times do |x|
                (Window.height/SQUARE_SIZE).times do |y|
                        yield(x, y)
                end

            end
        end 
        
        def draw_border(x, y)

            Line.new( width: 1, color: 'gray', y1: 0, y2: Window.height, x1: x * SQUARE_SIZE, x2: x * SQUARE_SIZE)

            Line.new( width: 1, color: 'gray', x1: 0, x2: Window.width, y1: y * SQUARE_SIZE, y2: y * SQUARE_SIZE)
            
        end

        def draw_square(x, y)

            n = self.get_number_of_live_neighbors(x, y)

            color = @colors[n] || "green"

            Square.new( color: color, x: x * SQUARE_SIZE, y: y * SQUARE_SIZE, size: SQUARE_SIZE)

        end
        
        def draw_lines
            self.each_squares  { |x, y| self.draw_border(x, y) } 
        end

    
        def each_neighbor(x, y)

            3.times do |a|

                3.times do |b|
                    
                    i = x+(a-1)
                    j = y+(b-1)

                    if [x,y] != [i,j]

                        yield(i, j)
                    end


                end 
            end

        end

        def get_neighbor_states(x, y)
            
            neighbors = {}

            self.each_neighbor(x, y) do |i, j|
                neighbors[[i, j]] = @grid[[i, j]]
            end

            return neighbors
        end

        def update_states
            
            new_grid = {}

            n_live_cells = 0

            self.each_squares do |x,y|

                state = @grid[[x, y]]

                n_neighbors = self.get_number_of_live_neighbors(x, y)

                if state == :alive 
                new_grid[[x,y]] = self.update_live_cell n_neighbors: n_neighbors

                else
                    new_grid[[x,y]] = self.update_dead_cell n_neighbors: n_neighbors
                end

                if new_grid[[x,y]] == :alive
                    n_live_cells  += 1
                end

            end
            
            @grid = new_grid

            if n_live_cells == 0
                @playing = false
            end

        end

        def update_dead_cell(n_neighbors:)

            return case n_neighbors

                    when 3 then :alive  

                    else :dead

                    end
        end

        def update_live_cell(n_neighbors:)

            return case n_neighbors

                    when 0..1 then :dead  
                        
                    when 2..3 then :alive
                        
                    else :dead
                        
                    end
        end


        def get_number_of_live_neighbors(x, y)

            n = 0

            self.each_neighbor(x, y) do |i, j| 
                
                if @grid[[i, j]] == :alive
                    n += 1
                end
            end

            return n
        end

        def manual_draw(x, y)

            x = x/SQUARE_SIZE
            y = y/ SQUARE_SIZE 

            @grid[[x, y]] = :alive

        end

        def process_input(key)

        
            case key

            when "p"
                @playing = !@playing 

            when "r"
                self.randomize_board 
                @playing = true  

            else    

            end
        end

        def draw_alive_squares
            
            @counter += 1
            if @counter % @refresh_rate == 0 
               self.update_states
            end   

            @grid.keys.each do |x, y|

                if @grid[[x,y]] == :alive
                    self.draw_square(x, y)
                end

            end
        end

    end


end