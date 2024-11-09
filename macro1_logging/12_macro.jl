# using Logging
using Base.CoreLogging

# Base.CoreLogging.logmsg_code((Base.CoreLogging.@_sourceinfo)..., esc(Logging.Info), exs...)
# 上条错误, @_sourceinfo 中取不了值

function sourceinfo()
    Base.CoreLogging.logmsg_code((Base.CoreLogging.@_sourceinfo)..., esc(Logging.Info), exs...)
end

macro sourceinfo()
    Base.CoreLogging.@_sourceinfo
end

"""
macro log(exs...)
    最终采用的方式
"""
macro log(exs...) 
    # typeof(exs) |> display
    exs = collect(exs)    
    not_show_my_debug = false  # 否定之否定 为肯定，即显示 

    # kind == :debug
    # if exs[1] isa Symbol && exs[1] in [:debug, :info, :warn, :error]
    #     kind = popfirst!(exs)
    # end  # :info, :warn, :error 没必要, 本身有@info, 所以注释掉，只针对debug

    # if kind == :debug && not_show_my_debug
    if not_show_my_debug
        return nothing
    end
    # println(Main.show_my_debug_info)
    # if ! Main.show_my_debug_info
    #     return nothing
    # end     

    exs[1] = exs[1] isa String ? exs[1] : string(exs[1])    
    # println("进行计算啦")
    
    if exs[end] in [1, 2, 3]
        hr_level = pop!(exs)
    else
        hr_level = 1
    end
    
    # global level__hr
    hr = level__hr[hr_level]*exs[1]

    replacing = "\n      "
    replaced = replace(hr, '\n'=> replacing)
    if hr_level == "3" && length(exs[1]) == 0 
        replaced = replaced[1:end-7]
    end
    exs[1] =  replaced
    
    # display("exs")
    # exs |> display
    # sources = (Base.CoreLogging.@_sourceinfo)
    # sources |> display
              
    # Base.CoreLogging.logmsg_code(sources..., esc(Logging.Debug), exs...)
    # Base.CoreLogging.logmsg_code((Base.CoreLogging.@_sourceinfo)..., esc(Logging.Info), exs...)
    Base.CoreLogging.logmsg_code(
            (Base.CoreLogging.@_sourceinfo)..., 
            esc(Base.CoreLogging.Info), exs...
            ) # Base.CoreLogging.Info 和 Logging.Info相同
    # display("after logmsg_code")  
    # 有这个display后报错: VSCodeDebugger.JuliaInterpreter
    # ArgumentError: lowering did not return a `:thunk` expression, got nothing      
    
end

"""
macro log1(exs...) 
    using Logging
    logger = ConsoleLogger(stderr, Logging.Info)
    debuglogger = ConsoleLogger(stderr, Logging.Debug)
    global_logger(debuglogger)

    global_logger 有效, 
    但log输出测试有点乱
    但所有程序的 global_logger 打开啦, vscode julia插件的debug信息也会显示
"""
macro log1(exs...) 
    # level = eval(:($(esc(:Info))))
    # std_level = eval(:($(level isa Symbol ? :level : :(level isa $LogLevel ? level : convert($LogLevel, level)::$LogLevel))))
    # level |> display
    # std_level |> display
    # if std_level >= eval(:($(Base.CoreLogging._min_enabled_level)[]))
    
    (@__MODULE__) |> display # Main
    global_logger() |> display
    debuglogger |> display       
    
    Logging.min_enabled_level(global_logger()).level |> display
    treated_exs = "未处理 exs ..."

    if Logging.min_enabled_level(global_logger()).level < 0

        exs = processed_exs(exs)
        exs |> display

        sources = (Base.CoreLogging.@_sourceinfo)
        sources |> display
                
        # Base.CoreLogging.logmsg_code(sources..., esc(Logging.Debug), exs...)
        Base.CoreLogging.logmsg_code(sources..., esc(Logging.Info), exs...)
        # Base.CoreLogging.logmsg_code(sources..., :Debug, exs...)           
            
        treated_exs = "处理了 exs ..."
    end
    
    display(treated_exs)
    
end

"""
macro log2:
debuglogger 设为全局logger,并且最后设置 esc(Logging.Debug)
会把 vscode julia插件中的debug信息也显示出来, 太多
"""
macro log2(exs...)

    global_logger() |> display
    older_logger = global_logger()

    if Logging.min_enabled_level(older_logger).level >= 0
        debuglogger = ConsoleLogger(stderr, Logging.Debug)        
        global_logger(debuglogger) #  debuglogger 设为全局logger
    end
    global_logger() |> display

    exs = processed_exs(exs)
    exs |> display      

    Base.CoreLogging.logmsg_code(
        (Base.CoreLogging.@_sourceinfo)..., 
        esc(Logging.Debug), exs...
        ) # 若是Logging.Info也会显示，因为启用了全局 debuglogger的Debug Level
end

"""
macro log3(exs...)
    with_logger(debuglogger),
    只改变当层, 子层logmsg_code还是该不了默认的Info level
"""
macro log3(exs...)

    global_logger() |> display  # 这些函数在 Base.CoreLogging
    older_logger = global_logger()

    if Logging.min_enabled_level(older_logger).level >= 0
        debuglogger = ConsoleLogger(stderr, Logging.Debug)
        # global_logger(debuglogger)
    end

    with_logger(debuglogger) do
        debuglogger |> display
        @debug "debug is here" # 没问题     
    
        exs = processed_exs(exs)
        
        sources = Base.CoreLogging.@_sourceinfo

        # Base.CoreLogging.logmsg_code(sources...,esc(Logging.Debug), exs...)
        # Julia默认显示info及以上的信息，所以上条的话，没有反应 不显示
        # Base.CoreLogging.logmsg_code(sources...,esc(debuglogger.min_level), exs...)
        # 同样不行

        Base.CoreLogging.logmsg_code(sources...,esc(Logging.Info), exs...)  # 可以
        # Base.CoreLogging.logmsg_code(sources...,esc(older_logger.min_level), exs...)
        # older_logger.min_level 和 Loging.info 的结果都是 Info::LogLevel
        
        # display("处理啦")  # 有这句话出现bug
    end
end