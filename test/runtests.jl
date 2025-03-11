using Test
using TropicalNumbers, Graphs, LinearAlgebra
using .MyFirstPackage

@testset "MyFirstPackage 测试" begin
    # 基础维度测试
    @testset "基础属性" begin
        @test size(MyFirstPackage.tmat) == (10, 10)
        @test eltype(MyFirstPackage.tmat) == TropicalMinPlus{Float64}
    end

    # 对角线测试
    @testset "对角线元素" begin
        for i in 1:10
            @test MyFirstPackage.tmat[i,i] == TropicalMinPlus(0.0)
        end
    end

    # 元素分布测试
    @testset "元素值验证" begin
        ones_cnt = 0
        twos_cnt = 0
        
        for i in 1:10, j in 1:10
            if i == j
                continue  # 跳过对角线
            end
            
            val = MyFirstPackage.tmat[i,j].n  # 确保 TropicalMinPlus 包含 .n 字段
            if val ≈ 1.0
                ones_cnt += 1
            elseif val ≈ 2.0
                twos_cnt += 1
            else
                error("异常值 $val 在位置 ($i,$j)")
            end
        end

        @test ones_cnt == 30 || error("邻接边数验证失败: 期望 30，实际 $ones_cnt")
        @test twos_cnt == 60 || error("非邻接路径验证失败: 期望 60，实际 $twos_cnt")
    end

    # 幂等性测试（确保结果稳定）
    @testset "幂等性验证" begin
        tmat_squared = MyFirstPackage.tmat^2  # 确保定义了 ^ 运算符
        @test tmat_squared == MyFirstPackage.tmat || error("幂次结果不稳定")
    end
end