
# This file is adapted from JuliaArrays/StaticArrays.jl License is MIT:
# https://github.com/JuliaArrays/StaticArrays.jl/blob/master/LICENSE.md

# Cast any Tuple to an TupleN{T}
@inline convert_ntuple(::Type{T},d::T) where {T} = T # For zero-dimensional arrays
@inline convert_ntuple(::Type{T},d::NTuple{N,T}) where {N,T} = d
@generated function convert_ntuple(::Type{T}, d::NTuple{N,Any}) where {N,T}
    exprs = ntuple(i -> :(convert(T, d[$i])), Val(N))
    return quote
        @_inline_meta
        $(Expr(:tuple, exprs...))
    end
end

# Base gives up on tuples for promote_eltype... (TODO can we improve Base?)
@generated function promote_tuple_eltype(::Union{T,Type{T}}) where T <: Tuple
    t = Union{}
    for i = 1:length(T.parameters)
        tmp = Base.unwrapva(T.parameters[i])
        t = :(promote_type($t, $tmp))
    end
    return quote
        @_inline_meta
        $t
    end
end

