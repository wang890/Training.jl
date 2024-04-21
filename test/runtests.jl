# https://bbs.huaweicloud.com/blogs/388401

using Test
using Training

@testset "Training.jl" begin
    @test Training.sum(2,3) == 5
    @test Training.mul(2,3) == 6
end
