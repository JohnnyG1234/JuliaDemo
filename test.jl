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


function main()
    @time histo()
end
main()