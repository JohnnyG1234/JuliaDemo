using Plots
using PlotThemes
using ImageMagick

gr()

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

function game_of_life()
    theme(:dracula ::Symbol;)
    n = 300
    my_matrix = generate_starting_pos()

    anim = @animate for i in 1:n 
        heatmap(my_matrix, color = :greys) 
        new_matrix  = copy(my_matrix)
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
                if neighbor_count <= 1
                    new_matrix[i] = 0 
                elseif neighbor_count >= 4
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

#=
function get_neighbors(x, y)
    neighbors = []
    push!(neighbors, [x+1, y])
    push!(neighbors, [x-1, y])
    push!(neighbors, [x, y+1])
    push!(neighbors, [x, y-1])
    push!(neighbors, [x-1, y-1])
    push!(neighbors, [x+1, y+1])
    push!(neighbors, [x-1, y+1])
    push!(neighbors, [x+1, y-1])

    neighbors
end
=#
function generate_starting_pos()
    my_matrix = zeros(Int8, 60, 60)
    spawn_chance = 5

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