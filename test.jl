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
    my_matrix = zeros(Int8, 100, 160)

    anim = @animate for i in 1:n 
        my_matrix[rand(1:100), rand(1:160)] = 1
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


function main()
    
    #@time histo()
    game_of_life()

end



main()