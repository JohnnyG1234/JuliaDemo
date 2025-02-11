using Plots
using PlotThemes

theme(:dracula ::Symbol;)

f(x) = 10*sin(x)
g(x) = x^2

plot([f,g], 0, 2*pi, title="f and g plot")