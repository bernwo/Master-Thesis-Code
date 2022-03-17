function output = cost_func_NFT(Latt,tau_ph,L,L0,er_index,c,t0,t1,t2,eta_e_func,r0_inv_func,tau_cz)
    import One_way_quantum_repeaters.m
    import One_way_quantum_repeaters.secretkeyrate_func_NFT
    n = L./(L0*c);

    type_I_weight = 27; % 3^3
    type_II_weight = 216; % (3+3)^3
    m_eval = type_I_weight.*(n-1).*c + type_II_weight.*c;
    [~,~,rs_val] = secretkeyrate_func_NFT(L,L0,er_index,c,t0,t1,t2,eta_e_func,r0_inv_func,tau_cz,false);
    output = m_eval.*Latt./( rs_val.*tau_ph.*L );
end