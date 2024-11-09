include("11_macro_common.jl")
include("12_macro.jl")

@log 55 dct arr
# jl模式下 无 module file line信息

# @log1 55 dct arr

# @log2 55 dct arr

# @log3 55 dct arr

@info dct arr
@info "" dct arr

@info "End"