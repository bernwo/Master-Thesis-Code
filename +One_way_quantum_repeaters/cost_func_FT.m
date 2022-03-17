function output = cost_func_FT(Latt,tau_ph,L,L0,er_index,c,t0,t1,t2,eta_e_func,r0_inv_func,tau_cz)
    import One_way_quantum_repeaters.m
    import One_way_quantum_repeaters.secretkeyrate_func_FT
    n = L./(L0*c);
%     n = (L./L0 + 1)./(c);
%     m_eval = m(L,L0);
    type_I_weight = 135; % 5*(3^3)
    type_II_weight = 12167; % (23^3)
    m_eval = type_I_weight.*(n-1).*c + type_II_weight.*c;
    [~,~,rs_val] = secretkeyrate_func_FT(L,L0,er_index,c,t0,t1,t2,eta_e_func,r0_inv_func,tau_cz,false);
    output = m_eval.*Latt./( rs_val.*tau_ph.*L );
end