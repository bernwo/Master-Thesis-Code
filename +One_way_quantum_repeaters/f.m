function output = f(error)
    import One_way_quantum_repeaters.h
    Q_eval = One_way_quantum_repeaters.Q(error);
    output = 1 - h(Q_eval) - Q_eval - (1-Q_eval).*h((1-3.*Q_eval./2)./(1-Q_eval));
end

