module MyFirstPackage

using TropicalNumbers, LinearAlgebra, Graphs

export compute_tropical_matrix!, TropicalResult

# 定义结果类型用于封装计算过程数据
struct TropicalResult{T<:Real}
    graph::SimpleGraph
    adj_matrix::Matrix{Int}
    tropical_adj::Matrix{TropicalMinPlus{T}}
    tropical_mat::Matrix{TropicalMinPlus{T}}
    powered_mat::Matrix{TropicalMinPlus{T}}
end

function compute_tropical_matrix!(g::SimpleGraph=smallgraph(:petersen); power::Int=10)::TropicalResult{Float64}
    # 生成邻接矩阵
    adj = Matrix(adjacency_matrix(g))
    
    # 转换为热带数矩阵
    trop_adj = map(x -> iszero(x) ? TropicalMinPlus(Inf) : TropicalMinPlus(1.0), adj)
    
    # 添加对角线
    trop_mat = trop_adj + Diagonal([TropicalMinPlus(0.0) for _ in 1:nv(g)])
    
    # 计算矩阵幂
    powered = trop_mat^power
    
    # 返回封装结果
    return TropicalResult(g, adj, trop_adj, trop_mat, powered)
end

end