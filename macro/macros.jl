# macro show_expr(expr)
#     println("Expression: ", expr)
#     return esc(expr)
# end

# # @show_expr 2+3

# macro sayhello()
#     return :( println("Hello, world!") )
# end

# macro sayhello(name)
#     return :( println("Hello, ", $name) )
#     end

# # @sayhello()

# @sayhello("Human")

macro tid(expre)
    quote
        local t0 =time()
        local val = $expre
        elapsedtime = time()-t0
        println("$elapsedtime seconds")
        val
    end
end

@tid map(x->x^2, 1:10000)

@info "End"

