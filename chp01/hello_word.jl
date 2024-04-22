# ## 分节
# Shift + Enter 在 REPL 运行鼠标所在的行， Ctrl + Enter也是
# Alt + Shift +Ener 在 REPL 运行鼠标所在的节

using DataFrames
using ArrayLayouts
using LinearAlgebra


function f(x)
    x*x
end
b = f(2)

##
c=3
cc=33


##

size = Sys.WORD_SIZE

str = "Hello World"

arx = [1 3
               2 4]
df = DataFrame(arx, :auto)
v = view(Symmetric(arx),:,:)
aaa = 3