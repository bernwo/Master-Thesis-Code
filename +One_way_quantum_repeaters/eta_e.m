function output = eta_e(L0,Latt,eta_d,d)
    import One_way_quantum_repeaters.mu One_way_quantum_repeaters.b One_way_quantum_repeaters.R
    mu_eval = mu(L0,Latt,eta_d);
    R1 = R(1,L0,Latt,eta_d,d);
    R2 = R(2,L0,Latt,eta_d,d);
    b0d = b(0,d);
    output = ((1-mu_eval+mu_eval.*R1).^b0d - (mu_eval.*R1).^b0d).*(1-mu_eval+mu_eval.*R2).^b(1,d);
end