using MyFirstPackage
using Test
using Graphs, TropicalNumbers, LinearAlgebra

@testset "MyFirstPackage Integration Tests" begin
    # 生成默认测试数据（Petersen图）
    result = MyFirstPackage.compute_tropical_matrix!()
    
    # --- 基础属性验证 ---
    @testset "Basic Structure" begin
        @test result isa MyFirstPackage.TropicalResult
        @test nv(result.graph) == 10
        @test ne(result.graph) == 15
        @test size(result.adj_matrix) == (10, 10)
    end

    # --- 邻接矩阵转换验证 ---
    @testset "Adjacency Matrix Conversion" begin
        # 验证原始邻接矩阵
        @test all(sum(result.adj_matrix, dims=1) .== 3)  # 每个节点度数为3
        @test result.adj_matrix == result.adj_matrix'  # 对称性
        
        # 验证热带转换
        for i in 1:10, j in 1:10
            if result.adj_matrix[i, j] == 0
                @test result.tropical_adj[i, j] == TropicalMinPlus(Inf)
            else
                @test result.tropical_adj[i, j] == TropicalMinPlus(1.0)
            end
        end
    end

    # --- 矩阵构造验证 ---
    @testset "Matrix Construction" begin
        # 验证对角线
        @test all(result.tropical_mat[i, i] == TropicalMinPlus(0.0) for i in 1:10)
        
        # 验证非对角元素
        @test all(result.tropical_mat[i, j] == result.tropical_adj[i, j] for i in 1:10, j in 1:10 if i != j)
    end

    # --- 幂运算验证 ---
    @testset "Matrix Power Calculation" begin
        # 自反性
        @test all(result.powered_mat[i, i] == TropicalMinPlus(0.0) for i in 1:10)
        
        # 邻接节点距离
        for e in edges(result.graph)
            u, v = src(e), dst(e)
            @test result.powered_mat[u, v] == TropicalMinPlus(1.0)
            @test result.powered_mat[v, u] == TropicalMinPlus(1.0)
        end
        
        # 非邻接节点距离（Petersen图特性）
        non_edges = [(i, j) for i in 1:10, j in 1:10 if i != j && result.adj_matrix[i, j] == 0]
        for (i, j) in non_edges[1:min(5, length(non_edges))]
            @test result.powered_mat[i, j] == TropicalMinPlus(2.0)
        end
    end

    # --- 参数化测试 ---
    @testset "Parameterized Tests" begin
        # 测试不同图结构
        complete_g = complete_graph(3)
        complete_res = MyFirstPackage.compute_tropical_matrix!(complete_g, power=2)
        
        @test nv(complete_res.graph) == 3
        @test all(complete_res.powered_mat .== TropicalMinPlus(1.0))  # 完全图两步可达所有节点
        
        # 测试不同幂次
        power5_res = MyFirstPackage.compute_tropical_matrix!(power=5)
        @test power5_res.powered_mat == result.powered_mat  # 验证幂等性
    end
end