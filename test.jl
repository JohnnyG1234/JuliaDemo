using Plots
using PlotThemes
using ImageMagick
gr()

function game_of_life()
    theme(:dracula ::Symbol;)
    n = 200
    my_matrix = generate_starting_pos()

    anim = @animate for i in 1:n 
        if n != 1
            heatmap(my_matrix, color = :greys) 
        end 
        new_matrix  = deepcopy(my_matrix)
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

    gif(anim, "anim.mp4", fps=5)
end

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

function main()
    #@time histo()

    # using the time macro to track performance
    @time game_of_life()
end

main()