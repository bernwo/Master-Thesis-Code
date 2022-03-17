function output = secretkeyrate_func_NOCONCAT(L,L0,er,t0,t1,t2,eta_e_func,r0_inv_func)
    import One_way_quantum_repeaters.m One_way_quantum_repeaters.f One_way_quantum_repeaters.etrans
    
    m_eval = m(L,L0);
    eta_e_eval = eta_e_func(L0,t0,t1,t2);
    
    ptrans = eta_e_eval.^(m_eval+1);
    
    error = etrans(L,L0,er);
    output = 1./r0_inv_func(t0,t1,t2) .* max(f(error),0).*ptrans;
end