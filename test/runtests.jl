using ObjectPools, Test
using ObjectPools: HomogeneousArrayPool, _new!, _recycle!

####
#### tests for internals
####

###
### HomogeneousArrayPools
###

@testset "HomogeneousArrayPool (internals)" begin
    T = Float64
    D = (2,4,3)
    h = HomogeneousArrayPool{T}(D)
    @test h.used == 0
    A1 = _new!(h)
    @test A1 isa Array{T,3} && size(A1) == D
    A2 = _new!(h)
    @test A1 ≢ A2
    @test A2 isa Array{T,3} && size(A2) == D
    @test h.used == 2
    @test _recycle!(h) ≡ nothing
    @test h.used == 0
    @test length(h.arrays) == 2
    @test _new!(h) ≡ A1
    @test _new!(h) ≡ A2
    @test h.used == 2
    A3 = _new!(h)
    @test A3 isa Array{T,3} && size(A3) == D && A1 ≢ A3 ≢ A2
    @test length(h.arrays) == h.used == 3
end

####
#### tests for exposed API
####

@testset "ArrayPool" begin
    pool = ArrayPool()
    D = (3, 2)
    A1 = @inferred new!(pool, Array{Float64}, D)
    @test A1 isa Matrix{Float64} && size(A1) == D
    A2 = @inferred new!(pool, Vector{Int}, 9)
    @test A2 isa Vector{Int} && length(A2) == 9
    @test recycle!(pool) ≡ nothing
    @test A1 ≡ @inferred new!(pool, Matrix{Float64}, D)
    @test A2 ≡ @inferred new!(pool, Array{Int}, 9)
end
