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
    n = 100
    my_matrix = generate_starting_pos()

    anim = @animate for i in 1:n 
        
        # looping through 2d array with one for loop!!!
        #  https://julialang.org/blog/2016/02/iteration/ more cool Julia looping methods
        for i in CartesianIndices(my_matrix)
            # Julia tuples not zero indexed for some reason.... mathematician moment 🤮
            neighbors = get_neighbors(i[1], i[2])

            neighbor_count = 0
            for n in eachindex(neighbors)
                i = neighbors[n][1]
                j = neighbors[n][2]

                try
                    if my_matrix[i, j] == 1
                        neighbor_count += 1
                    end
                catch
                end
            end
            
            # if cell is alone or to crowded it dies
            if my_matrix[i] == 1
                if neighbor_count <= 1
                    my_matrix[i] = 0 
                elseif neighbor_count >= 4
                    my_matrix[i] = 0 
                end
            else
                if neighbor_count == 1
                    my_matrix[i] = 1
                end
            end
            

        end


        println(my_matrix)
        heatmap(my_matrix, color = :greys) 
    end

    gif(anim, "anim.mp4", fps=30)
end

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

function generate_starting_pos()
    my_matrix = zeros(Int8, 100, 100)
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