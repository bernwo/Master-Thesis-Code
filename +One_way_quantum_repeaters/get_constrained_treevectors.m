function output = get_constrained_treevectors(d_constraint,n_constraint)
    minimum_vector = 3;
    maxiter = 300000;
    output = [];
    temp = zeros(1,d_constraint+1) + minimum_vector;
    previous_temp = zeros(1,d_constraint+1) + minimum_vector;
    break_completely = false;
    while ~(break_completely) && maxiter > 1
       output = cat(1,output,temp);
       temp(end) = temp(end) + 1;
       while One_way_quantum_repeaters.photon_number(temp) > n_constraint
          index = find((temp-previous_temp)~=0);
          temp(index(1):end) = minimum_vector; % resets
          if (index(1) - 1) >= 1
              temp(index(1)-1) = temp(index(1)-1) + 1;
          else
              break_completely = true;
              break;
          end
       end
       previous_temp = temp;
       maxiter = maxiter - 1;
    end
end