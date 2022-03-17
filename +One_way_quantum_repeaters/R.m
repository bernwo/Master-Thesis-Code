function output = R(k,L0,Latt,eta_d,d)
    % Params
    % ------
    %   k: Integer
    %       Starts from 0.
    %   L0: Double
    %   Latt: Double
    %   eta_d: Double
    %   d: Integer
    import One_way_quantum_repeaters.mu One_way_quantum_repeaters.b One_way_quantum_repeaters.R
    if k <= d
        mu_eval = mu(L0,Latt,eta_d);
        output = 1-(1-(1-mu_eval).*(1-mu_eval+mu_eval.*R(k+2,L0,Latt,eta_d,d)).^(b(k+1,d))).^(b(k,d));
    else
        output = 0;
    end
end