using Plots, Base.Threads

# ----------- Helper Functions -----------
function get_neighbors(x, y, grid_size)
    rows, cols = grid_size
    neighbors = [(x+dx, y+dy) for dx in -1:1 for dy in -1:1 if !(dx == 0 && dy == 0)]
    filter(n -> 1 ≤ n[1] ≤ rows && 1 ≤ n[2] ≤ cols, neighbors)
end

# ----------- Game of Life (Optimized) -----------
function update_cell(state::Int8, alive_neighbors::Int)
    if state == 1 && (alive_neighbors < 2 || alive_neighbors > 3)
        return 0  # Dies
    elseif state == 0 && alive_neighbors == 3
        return 1  # Becomes alive
    end
    return state  # Remains unchanged
end

function update_game_of_life(grid)
    rows, cols = size(grid)
    new_grid = copy(grid)

    @threads for x in 1:rows
        for y in 1:cols
            alive_neighbors = count(grid[n...] == 1 for n in get_neighbors(x, y, size(grid)))
            new_grid[x, y] = update_cell(grid[x, y], alive_neighbors)
        end
    end
    return new_grid
end

function run_game_of_life(grid_size=(50, 50), steps=100)
    grid = rand([0, 1], grid_size)
    anim = @animate for _ in 1:steps
        heatmap(grid, color=:gray, title="Game of Life")
        grid = update_game_of_life(grid)
    end
    gif(anim, "game_of_life.gif", fps=10)
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
            run_game_of_life()
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
