using Plots

x = 0:10
y = sin.(x)
p = plot(x,y)
display(p)

@info "End"
