function output = mu(L0,Latt,eta_d)
    output = 1 - One_way_quantum_repeaters.eta(L0,Latt).*eta_d;
end