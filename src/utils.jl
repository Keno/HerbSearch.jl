bfs_priority_function(::Grammar, ::AbstractRuleNode, parent_value::Union{Real, Tuple{Vararg{Real}}}) = parent_value + 1
bfs_expand_heuristic(rules) = rules


"""
Returns a breadth-first search enumerator. Returns trees in the grammar in increasing order of size. 
"""
function get_bfs_enumerator(grammar::ContextFreeGrammar, max_depth::Int, max_size::Int, sym::Symbol)::ContextSensitivePriorityEnumerator
    expand_function(node, grammar, max_depth, context) = _expand(node, grammar, max_depth, context, bfs_expand_heuristic)
    return ContextFreePriorityEnumerator(grammar, max_depth, max_size, bfs_priority_function, expand_function, sym)
end

function get_bfs_enumerator(grammar::ContextSensitiveGrammar, max_depth::Int, max_size::Int, sym::Symbol)::ContextSensitivePriorityEnumerator
    expand_function(node, grammar, max_depth, context) = _expand(node, grammar, max_depth, context, bfs_expand_heuristic)
    return ContextSensitivePriorityEnumerator(grammar, max_depth, max_size, bfs_priority_function, expand_function, sym)
end

dfs_priority_function(::Grammar, ::AbstractRuleNode, parent_value::Union{Real, Tuple{Vararg{Real}}}) = parent_value - 1
dfs_expand_heuristic(rules) = rules


"""
Returns a depth-first search enumerator. Returns trees in the grammar in decreasing order of size.
"""
function get_dfs_enumerator(grammar::ContextFreeGrammar, max_depth::Int, max_size::Int, sym::Symbol)::ContextSensitivePriorityEnumerator
    expand_function(node, grammar, max_depth, context) = _expand(node, grammar, max_depth, context, dfs_expand_heuristic)
    return ContextFreePriorityEnumerator(grammar, max_depth, max_size, dfs_priority_function, expand_function, sym)
end

function get_dfs_enumerator(grammar::ContextSensitiveGrammar, max_depth::Int, max_size::Int, sym::Symbol)::ContextSensitivePriorityEnumerator
    expand_function(node, grammar, max_depth, context) = _expand(node, grammar, max_depth, context, dfs_expand_heuristic)
    return ContextSensitivePriorityEnumerator(grammar, max_depth, max_size, dfs_priority_function, expand_function, sym)
end

function most_likely_priority_function(g::Grammar, tree::AbstractRuleNode, ::Union{Real, Tuple{Vararg{Real}}})
    -rulenode_log_probability(tree, g)
end

"""
Returns an enumerator that enumerates expressions in the grammar in decreasing order of probability.
Only use this function with probabilistic grammars.
"""
function get_most_likely_first_enumerator(grammar::ContextFreeGrammar, max_depth::Int, max_size::Int, sym::Symbol)::ContextSensitivePriorityEnumerator
    expand_function(node, grammar, max_depth, context) = _expand(node, grammar, max_depth, context, identity)
    return ContextFreePriorityEnumerator(grammar, max_depth, max_size, most_likely_priority_function, expand_function, sym)
end

function get_most_likely_first_enumerator(grammar::ContextSensitiveGrammar, max_depth::Int, max_size::Int, sym::Symbol)::ContextSensitivePriorityEnumerator
    expand_function(node, grammar, max_depth, context) = _expand(node, grammar, max_depth, context, identity)
    return ContextSensitivePriorityEnumerator(grammar, max_depth, max_size, most_likely_priority_function, expand_function, sym)
end