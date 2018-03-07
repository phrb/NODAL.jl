@testset "Run" begin
    @testset "constructors" begin
        tuning_run = Run()
        @test typeof(tuning_run) <: Run
    end
end
