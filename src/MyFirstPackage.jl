module MyFirstPackage

using TropicalNumbers, LinearAlgebra, Graphs

export tmat

# 你的代码
adj_mat = Matrix(adjacency_matrix(smallgraph(:petersen)))

tropical_adj = map(x -> iszero(x) ? TropicalMinPlus(Inf) : TropicalMinPlus(1.0), adj_mat)
tropical_mat = tropical_adj + Diagonal([TropicalMinPlus(0.0) for _ in 1:10])

global tmat = tropical_mat^10 

end  