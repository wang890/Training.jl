# 源文件代码太多；另外出现Base和Main的混淆
# 该案例不成功，不再测试

include("21_Julia_CoreLogging_copy.jl")
using .CoreLogging

macro log(exs...)

    Main.CoreLogging.global_logger() |> display

    older_logger = Main.CoreLogging.global_logger()

    if Main.CoreLogging.min_enabled_level(older_logger).level >= 0

        debuglogger = Main.CoreLogging.ConsoleLogger(stderr, Logging.Debug)
        # global_logger(debuglogger)
    end

    Main.with_logger(debuglogger) do
        debuglogger |> display
        # Main.CoreLogging.@debug "debug is here"      
    
        exs = processed_exs(exs)
        
        sources = Main.CoreLogging.@_sourceinfo
        sources |> display
        Main.Logging.Debug |>display

        Main.CoreLogging.logmsg_code(sources...,esc(Main.Logging.Debug), exs...)
    end
end
