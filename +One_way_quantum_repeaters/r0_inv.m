function output = r0_inv(d,tau_ph,tau_CZ)
    b0d = One_way_quantum_repeaters.b(0,d);
    output = b0d.*((100+r0_helper(d)).*tau_ph+(3+r0_helper(d-1)).*tau_CZ);
end

function output = r0_subhelper(x,bulk,d)
    output = One_way_quantum_repeaters.b(x,d).*(1+bulk);
end

function output = r0_helper(d)
    counter = 0;
    i = d;
%     output = 0;
    while i>0
       if counter == 0
           output = One_way_quantum_repeaters.b(i,d);
       else
           output = r0_subhelper(i,output,d);
       end
       i = i - 1;
       counter = counter + 1;
    end
end