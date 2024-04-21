# ## 分节
# Shift + Enter 在 REPL 运行鼠标所在的行， Ctrl + Enter也是
# Alt + Shift +Ener 在 REPL 运行鼠标所在的节

# https://jkrumbiegel.com/pages/2021-06-07-macros-for-beginners/

function show_value(x)
    println("The value you passed is ", x)
end

orange = "sweet"
apple = "sour"

show_value(orange)
show_value(apple)

##

# If we want to incorporate the information contained in the variable names, we need a macro.
macro show_value(variable)
    quote
        println("The ", $(string(variable)), " you passed is ", $(esc(variable))) 
        # Main.println("The ", "orange", " you passed is ", orange)

        # println("The ", $(string(variable)), " you passed is ", variable)         
        # # Main.println("The ", "orange", " you passed is ", Main.variable)

        println("The ", $(string(variable)), " you passed is ", $variable)        
        # Main.println("The ", "orange", " you passed is ", Main.orange)

        # # println("The ", $(string($variable)), " you passed is ", $variable)

        # println("The ", $(variable), " you passed is ", $(esc(variable)))
        #          # Main.println("The ", Main.orange, " you passed is ", orange)

        # println("The ", string(variable), " you passed is ", $(esc(variable)))
        # # Main.println("The ", Main.string(Main.variable), " you passed is ", orange)

        # println("The ", $(string(variable)), " you passed is ", esc(variable))   
        #  # Main.println("The ", "orange", " you passed is ", Main.esc(Main.variable))

        # println("The ", $(string(variable)), " you passed is ", $esc(variable))   
        # # Main.println("The ", "orange", " you passed is ", (esc)(Main.variable))
    end
end

orange = "sweet"
# apple = "sour"
# string(orange)
# @show orange
# Meta.@dump orange

@macroexpand @show_value(orange)



@show_value(orange)
# @show_value(apple)

##


module SomeModule
    export @show_value_no_esc

    # orange = "sweet"
    # apple = "sour"
    
    macro show_value_no_esc(variable)
        quote
            println("The ", $(string(variable)), " you passed is ", $variable)
            # Main.SomeModule.println("The ", "orange", " you passed is ", Main.SomeModule.orange)
        end
    end
end

using .SomeModule

orange = "sweet"
apple = "sour"

@macroexpand @show_value_no_esc(orange)

##

try
    @show_value_no_esc(orange)
catch e
    sprint(showerror, e)
end

##

macro change_nothing(exp)
    e = quote
        temp_variable = nothing # this could be some intermediate computation
        $exp # we actually just pass the input expression back unchanged
    end
    # esc(e) # but everything is escaped
    # e  # 使用这个时  temp_variable 不会被更改
end

temp_variable = "important information"

##

@macroexpand @change_nothing 1+1

##

x = @change_nothing 1 + 1
@show x
@show temp_variable

##

# Module定义，以及Module总宏函数的定义
module AnotherModule
    export @show_value_user_and_module

    orange = "bitter"

    macro show_value_user_and_module(variable)
        quote
            println("The ", $(string(variable)), " you passed is ", $(esc(variable)), # orange
                " and the one from the module is ", $variable)  # Main.AnotherModule.orange
            # Main.AnotherModule.println("The ", "orange", " you passed is ", orange, " 
            # and the one from the module is ", Main.AnotherModule.orange) 
        end
    end
end

# 开始程序
orange = "sweet"
using .AnotherModule
##

@macroexpand @show_value_user_and_module orange
##

@show_value_user_and_module orange
##

macro fill(exp, sizes...)
   
    iterator_expressions = map(sizes) do s
        Expr(
            :(=),
            :_,
            quote 1:$(esc(s)) end
        )
    end
    
    Expr(
        :comprehension,
        esc(exp),
        iterator_expressions...
    )
end

@macroexpand @fill(rand(3), 5)

@info "End"
