using Test
using HerbSearch 
using HerbGrammar
using HerbCore

@testset "Sampling grammar" verbose=true begin 

    @testset "Sampling with rand() returns programs in the given max_depth" begin
        arithmetic_grammar = @cfgrammar begin
            X = X * X
            X = X + X
            X = X - X
            X = |(1:4)
        end
        
        # try for multiple depths
        for max_depth in 1:20
            expression_generated = rand(RuleNode, arithmetic_grammar, :X, max_depth)
            depth_generated = depth(expression_generated)
            
            @test depth(expression_generated) <= max_depth
        end
    end
    @testset "rand() gives the possible expressions for a certain max_depth" begin
        grammar = @cfgrammar begin 
            A = B | C | F
            F = G
            C = D
            D = E
        end
        # A->B (depth 1) or A->F->G (depth 2) or A->C->D->E (depth 3)

        # For depth ≤ 1 the only option is A->B
        expression = rand(RuleNode, grammar, :A, 1)
        @test depth(expression) == 1
        @test expression == RuleNode(1)
        @test rulenode2expr(expression,grammar) in [:B,:C,:F]

        # For depth ≤ 2 the two options are A->B (depth 1) and A->B->G| A->C->G | A->F->G (depth 2)
        expression = rand(RuleNode, grammar, :A, 2)
        @test depth(expression) == 1 || depth(expression) == 2
        @test rulenode2expr(expression,grammar) in [:B,:C,:F,:G]
        
    end

    @testset "Sampling throws an error if all expressions have a higher depth than max_depth" begin
        grammar = @cfgrammar begin 
            A = B 
            B = C
            C = D
            D = E
            E = F
        end
        # A->B->C->D->E->F (depth 5)
        real_depth = 5
        
        # it does not work for max_depth < 5
        for max_depth in 1:real_depth - 1
            @test_throws ErrorException expression = rand(RuleNode, grammar, :A, max_depth)
        end
        
        # it works for max_depth = 5
        expression = rand(RuleNode, grammar, :A, real_depth)
        @test depth(expression) == real_depth
    end
end