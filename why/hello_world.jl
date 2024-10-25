# ## 分节
# Shift + Enter 在 REPL 运行鼠标所在的行， Ctrl + Enter也是
# Alt + Shift +Ener 在 REPL 运行鼠标所在的节

using DataFrames
# using ArrayLayouts
using LinearAlgebra
using General.Aux

##

"""
f(x): 计算平方值
"""
function f(x)
    prompt = "计算平方值"
    x*x
end

a = f(2)

##
b=2+1im

b |> typeof |> display

b |> typeof |> fieldnames |> display

b |> propertynames |> display

c=3.0

@logt a b c

@logt a, b, c 

##

size = Sys.WORD_SIZE

str = "Hello World"
println(str)

arx = [1 3

               2 4]
df = DataFrame(arx, :auto)

v = view(Symmetric(arx),:,:)

@doc Symmetric

d = 4