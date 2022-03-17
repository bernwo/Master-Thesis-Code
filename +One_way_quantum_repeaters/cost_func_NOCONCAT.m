function output = cost_func_NOCONCAT(Latt,tau_ph,L,L0,er,t0,t1,t2,eta_e_func,r0_inv_func)
    import One_way_quantum_repeaters.m
    import One_way_quantum_repeaters.secretkeyrate_func_NOCONCAT
    m_eval = m(L,L0);
    rs_val = secretkeyrate_func_NOCONCAT(L,L0,er,t0,t1,t2,eta_e_func,r0_inv_func);
    output = m_eval.*Latt./( rs_val.*tau_ph.*L );
end