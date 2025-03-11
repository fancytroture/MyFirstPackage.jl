using MyFirstPackage
using Test
using Graphs, TropicalNumbers, LinearAlgebra
using Pkg
Pkg.test(; coverage=true)  # 启用代码覆盖率
@testset "MyFirstPackage Tests" begin

    # 验证邻接矩阵生成是否正确
    @testset "Adjacency Matrix Generation" begin
        adj = MyFirstPackage.adj_mat
        @test size(adj) == (10, 10)  # Petersen图应有10个节点
        @test adj == adj'  # 邻接矩阵应对称
        @test all(sum(adj, dims=1) .== 3)  # 每个节点的度数应为3
        @test all(iszero, diag(adj))  # 对角线无自环
    end

    # 验证热带邻接矩阵转换
    @testset "Tropical Adjacency Conversion" begin
        adj = MyFirstPackage.adj_mat
        trop_adj = MyFirstPackage.tropical_adj
        
        # 检查0元素转换为Inf，非零元素转换为1.0
        for i in 1:10, j in 1:10
            if adj[i, j] == 0
                @test trop_adj[i, j] == TropicalMinPlus(Inf)
            else
                @test trop_adj[i, j] == TropicalMinPlus(1.0)
            end
        end
    end

    # 验证带对角线的热带矩阵
    @testset "Tropical Matrix with Diagonal" begin
        trop_mat = MyFirstPackage.tropical_mat
        
        # 检查对角线是否为0.0
        @test all(trop_mat[i, i] == TropicalMinPlus(0.0) for i in 1:10)
        
        # 检查非对角元素与转换后的邻接矩阵一致
        @test all(trop_mat[i, j] == MyFirstPackage.tropical_adj[i, j] for i in 1:10, j in 1:10 if i != j)
    end

    # 验证矩阵幂运算结果
    @testset "Matrix Power Calculation" begin
        tmat = MyFirstPackage.tmat
        g = smallgraph(:petersen)
        
        # 自反性：节点到自身距离为0
        @test all(tmat[i, i] == TropicalMinPlus(0.0) for i in 1:10)
        
        # 相邻节点距离为1
        for e in edges(g)
            u, v = src(e), dst(e)
            @test tmat[u, v] == TropicalMinPlus(1.0)
            @test tmat[v, u] == TropicalMinPlus(1.0)  # 无向图对称性
        end
        
        # 非相邻节点距离为2（Petersen图直径为2）
        adj = MyFirstPackage.adj_mat
        non_edges = [(i, j) for i in 1:10, j in 1:10 if i != j && adj[i, j] == 0]
        @test !isempty(non_edges)  # 确保存在非邻接节点对
        for (i, j) in non_edges[1:min(5, length(non_edges))]  # 抽样测试5个非邻接对
            @test tmat[i, j] == TropicalMinPlus(2.0)
        end
        
        # 验证10次幂与2次幂结果相同（幂等性）
        trop_mat = MyFirstPackage.tropical_mat
        pow2 = trop_mat^2
        @test tmat == pow2
    end
end