function [ptrans,eta_e_eval,output] = secretkeyrate_func_FT(L,L0,er_index,c,t0,t1,t2,eta_e_func,r0_inv_func,tau_cz,doPrint)
    import One_way_quantum_repeaters.m One_way_quantum_repeaters.f One_way_quantum_repeaters.etrans
    import One_way_quantum_repeaters.eL_1Loss

%     n = 1/c * (L./L0 + 1);
    n = L/(L0*c);
    erfactor = 3;
    if n < 1
        eta_e_eval = 0;
        ptrans = 0;
        output = 1e-8; % Cheap workaround.
    else
        er = [1e-4 3e-4 5e-4 1e-3];
        eta_e_eval = eta_e_func(L0,t0,t1,t2);
        ptrans1 = eta_e_eval.^(5.*(n*c));
        % Binomial calculation
        rs_terms = 0;
        ptrans = ptrans1;
        if (c >= 2)
            eL_1loss_val = eL_1Loss(er(er_index)/erfactor,1-(1-er(er_index))^n);
            for k = 1:min(c,20) % maximum consider only k = 20. If more than that, then computation will be slow.
                binomialcoeff = nchoosek(c,k);
                ptrans_term = binomialcoeff .* eta_e_eval.^(5.*n.*(c-k))   .*   (5.*eta_e_eval.^(4.*n).*(1-eta_e_eval.^(n))).^k;
                ptrans = ptrans + ptrans_term;
                eL_0loss_val = One_way_quantum_repeaters.eL_FT_recursive2_et5_mex(er_index,n,c-k);
                assert(eL_0loss_val >= 0,"Recursive model returned NEGATIVE value for the error rate!!!");
                error_term = 1 - (1-eL_0loss_val)*(1-eL_1loss_val).^k;
                f_term = max( f(error_term) , 0 );
                if f_term <= 0 && doPrint
                    disp("Truncate at k="+num2str(k));
                    break;
                end
                rs_terms = rs_terms + ptrans_term*f_term;
            end
        end
        ec_noloss = One_way_quantum_repeaters.eL_FT_recursive2_et5_mex(er_index,n,c); % er_index here is set of indices i.e. {1,2,3,4,5}.

        rs_terms = ptrans1.*max(f(ec_noloss),0) + rs_terms;

        tau_spin_measure = 0; % seconds
        % Information: 3*16 + 3*16+8 = 136 two-qubit gate operations.
        output = 1./(r0_inv_func(t0,t1,t2) + 104*tau_cz + 5*tau_spin_measure) .* rs_terms;
    end
end