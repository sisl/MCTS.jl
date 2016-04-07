function next_action{S,A}(gen::RandomActionGenerator, mdp::PermissiveMDP, s, snode::DPWStateNode{S,A})
    if isnull(gen.action_space) 
        gen.action_space = Nullable{AbstractSpace}(actions(mdp))
    end
    rand(gen.rng, actions(mdp, s, get(gen.action_space)))
end
