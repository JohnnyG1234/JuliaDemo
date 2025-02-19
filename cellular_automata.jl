using Plots, Base.Threads, PlotThemes, ImageMagick

# ----------- Helper Functions -----------
function get_neighbors(x, y, grid_size)
    rows, cols = grid_size
    neighbors = [(x+dx, y+dy) for dx in -1:1 for dy in -1:1 if !(dx == 0 && dy == 0)]
    filter(n -> 1 ≤ n[1] ≤ rows && 1 ≤ n[2] ≤ cols, neighbors)
end

function generate_starting_pos()
    my_matrix = zeros(Int8, 60, 60)
    spawn_chance = 20

    # can loop through a row or an index in multidimensional array
    for row in eachrow(my_matrix)
        for i in eachindex(row)
            chance = rand(1:100)
            if chance <= spawn_chance
                row[i] = 1
            end
        end
    end

    my_matrix
end

# ----------- Game of Life (Optimized) -----------
function game_of_life()
    theme(:dracula::Symbol;)
    n = 200
    my_matrix = generate_starting_pos()

    anim = @animate for i in 1:n
        if n != 1
            heatmap(my_matrix, color=:greys)
        end
        new_matrix = deepcopy(my_matrix)
        # looping through 2d array with one for loop!!!
        #  https://julialang.org/blog/2016/02/iteration/ more cool Julia looping methods
        for i in CartesianIndices(my_matrix)
            # Julia tuples not zero indexed for some reason.... mathematician moment 🤮
            neighbors = get_neighbors(i[1], i[2], size(my_matrix))


            neighbor_count = 0
            for n in eachindex(neighbors)
                x = neighbors[n][1]
                y = neighbors[n][2]

                try
                    if my_matrix[x, y] == 1
                        neighbor_count += 1
                    end
                catch
                    continue
                end
            end
            #println(neighbor_count)

            # if cell is alone or to crowded it dies
            if my_matrix[i] == 1
                if neighbor_count <= 2 || neighbor_count > 3
                    new_matrix[i] = 0
                end
            else
                if neighbor_count >= 3
                    new_matrix[i] = 1
                end
            end
            my_matrix = new_matrix
        end
    end

    gif(anim, "game_of_life.gif", fps=5)
end

# ----------- Brian's Brain (Optimized) -----------
function update_brians_brain(grid)
    rows, cols = size(grid)
    new_grid = copy(grid)

    @threads for x in 1:rows
        for y in 1:cols
            alive_neighbors = count(grid[n...] == 1 for n in get_neighbors(x, y, size(grid)))
            if grid[x, y] == 0 && alive_neighbors == 2
                new_grid[x, y] = 1  # Birth
            elseif grid[x, y] == 1
                new_grid[x, y] = 2  # Dying
            elseif grid[x, y] == 2
                new_grid[x, y] = 0  # Dead
            end
        end
    end
    return new_grid
end

function run_brians_brain(grid_size=(50, 50), steps=100)
    grid = rand(0:1, grid_size)
    anim = @animate for _ in 1:steps
        heatmap(grid, color=:viridis, title="Brian's Brain")
        grid = update_brians_brain(grid)
    end
    gif(anim, "brians_brain.gif", fps=10)
end

# ----------- Langton's Ant (Optimized) -----------
function update_langtons_ant!(grid, pos, dir_idx)
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]  # Up, Right, Down, Left
    x, y = pos
    rows, cols = size(grid)

    # Change direction based on the color of the cell
    dir_idx = mod1(dir_idx + (grid[x, y] == 0 ? 1 : -1), 4)

    # Flip the color
    grid[x, y] = 1 - grid[x, y]

    # Move forward
    dx, dy = directions[dir_idx]
    x, y = mod1(x + dx, rows), mod1(y + dy, cols)

    return (x, y), dir_idx
end

function run_langtons_ant(grid_size=(101, 101), steps=11000)
    rows, cols = grid_size
    grid = zeros(Int8, rows, cols)
    pos = (div(rows, 2), div(cols, 2))
    dir_idx = 1  # Start facing up

    anim = @animate for _ in 1:steps
        pos, dir_idx = update_langtons_ant!(grid, pos, dir_idx)
        heatmap(grid, color=:binary, title="Langton's Ant", aspect_ratio=1)
    end

    gif(anim, "langtons_ant.gif", fps=60)
end

# ----------- Menu System -----------
function main_menu()
    while true
        println("\nSelect a Simulation:")
        println("1. Conway's Game of Life")
        println("2. Brian's Brain")
        println("3. Langton's Ant")
        println("4. Exit")
        print("Enter choice: ")

        choice = readline()

        if choice == "1"
            println("\nRunning Game of Life...")
            game_of_life()
            println("Saved as game_of_life.gif!")
        elseif choice == "2"
            println("\nRunning Brian's Brain...")
            run_brians_brain()
            println("Saved as brians_brain.gif!")
        elseif choice == "3"
            println("\nRunning Langton's Ant...")
            run_langtons_ant()
            println("Saved as langtons_ant.gif!")
        elseif choice == "4"
            println("Exiting program.")
            break
        else
            println("Invalid choice. Please enter 1, 2, 3, or 4.")
        end
    end
end

# Run the menu
main_menu()

#=
function circle_anim()
    theme(:dracula ::Symbol;)

    # equations
    x(t) = sin(t)
    y(t) = cos(t)
    
    # time frame
    t = 0:0.1:10
    n = length(t)
    
    xpos = x.(t)
    ypos = y.(t)
    
    anim = @animate for i in 1:n
        scatter!([xpos[i]], [ypos[i]], legend=:none, title="Trajectory",
        markersize=2, xaxis=("x", (-5, 5)), yaxis=("y", (-5,5)))
    
    end
    
    gif(anim, "anim.mp4", fps=15)
end


function histo()
    theme(:dracula ::Symbol;)
    n = 100
    anim = @animate for i in 1:n
        histogram2d(randn(5), randn(5), nbins = 20, xaxis=("x", (-5, 5)), yaxis=("y", (-5,5)))
    end
    gif(anim, "anim.mp4", fps=15)
end
=#