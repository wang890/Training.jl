strflag = "== == == Process Start"
dct =Dict("A" => 3, "B"=>Dict("name"=>"张三", "Age"=>24))
arr = [7, 8, 9]

exs = (:strflag, :dct, :arr)

level__hr = Dict(1 => "== "^7, 2 => "-- "^7, 3 => "   "^7*"\n",)

function processed_exs(exs)
    # typeof(exs) |> display
    exs = collect(exs)
    exs[1] = exs[1] isa String ? exs[1] : string(exs[1])

    if exs[end] in [1, 2, 3]
        hr_level = pop!(exs)
    else
        hr_level = 1
    end
    hr = level__hr[hr_level]*exs[1]
    
    replacing = "\n      "
    replaced = replace(hr, '\n'=> replacing)
    if hr_level == "3" && length(exs[1]) == 0 
        replaced = replaced[1:end-7]
    end
    exs[1] =  replaced

    return exs  
end
