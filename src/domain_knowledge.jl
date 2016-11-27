"""
    estimate_value(policy, state, depth)

Return an estimate of the value.

"""
POMDPs.@pomdp_func estimate_value(estimator::Any, mdp::Union{POMDP,MDP}, state, depth::Int)
estimate_value(f::Function, mdp::Union{POMDP,MDP}, state, depth::Int) = f(mdp, state, depth)
estimate_value(estimator::Number, mdp::Union{POMDP,MDP}, state, depth::Int) = convert(Float64, estimator)

"""
RolloutEstimator

If this is passed to the estimate_value field of the solver, rollouts will be used to estimate the value at the leaf nodes

Fields:
    solver::Union{Solver,Policy,Function}
        If this is a Solver, solve(solver, mdp) will be called to find the rollout policy
        If this is a Policy, the policy will be used for rollouts
        If this is a Function, a POMDPToolbox.FunctionPolicy with this function will be used for rollouts
"""
type RolloutEstimator
    solver::Union{Solver,Policy,Function} # rollout policy or solver
end

"""
SolvedRolloutEstimator

This is within the policy when a RolloutEstimator is passed to an AbstractMCTSSolver
"""
type SolvedRolloutEstimator
    policy::Policy
    rng::AbstractRNG
end

estimate_value(estimator::SolvedRolloutEstimator, mdp::MDP, state, depth::Int) = rollout(estimator, mdp, state, depth)

# this rollout function is really just here in case people search for rollout
function rollout(estimator::SolvedRolloutEstimator, mdp::MDP, s, d::Int)
    sim = RolloutSimulator(rng=estimator.rng, max_steps=d)
    POMDPs.simulate(sim, mdp, estimator.policy, s)
end

"""
    init_Q(initializer, mdp, s, a)

Return a value to initialize Q(s,a) to based on domain knowledge.

By default, returns 0.0.
"""
POMDPs.@pomdp_func init_Q(initializer::Any, mdp::Union{MDP,POMDP}, s, a)
init_Q(f::Function, mdp::Union{MDP,POMDP}, s, a) = f(mdp, s, a)
init_Q(n::Number, mdp::Union{MDP,POMDP}, s, a) = convert(Float64, n)

"""
    init_N(initializer, mdp, s, a)

Return a value to initialize N(s,a) to based on domain knowledge.

By default, returns 0.
"""
POMDPs.@pomdp_func init_N(initializer::Any, mdp::Union{MDP,POMDP}, s, a)
init_N(f::Function, mdp::Union{MDP,POMDP}, s, a) = f(mdp, s, a)
init_N(n::Number, mdp::Union{MDP,POMDP}, s, a) = convert(Int, n)
