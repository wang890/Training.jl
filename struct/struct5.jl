using DynamicQuantities

# run here，or in ipynb, or in REPL, can not see the default values 

@kwdef struct  VolumeDensityOfCharge
    quantity = "VolumeDensityOfCharge"; 
    unit = "C/m3"; 
    u = u"C/m^3"; 
    min = 0; 
end

a = 1