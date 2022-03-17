function output = get_constrained_treevectors2(d_constraint,n_constraint)
    % This version adds constraint on selected element(s) of the tree vector.
    % b_0 is the first element of the tree vector, i.e., \vec{t} =
    % [b_0,b_1,...,b_d].
    max_b_0 = 4;
    minimum_vector = 4;
    maxiter = 300000;
    output = [];
    temp = zeros(1,d_constraint+1) + minimum_vector;
    previous_temp = zeros(1,d_constraint+1) + minimum_vector;
    break_completely = false;
    while ~(break_completely) && maxiter > 1
       if ((temp(1) <= max_b_0) && (temp(1) <= temp(2)) && (temp(2) >= temp(3))) % Artificially inserted constraint. Makes numerical optimisation faster and the cases ignored are already known to be non-optimum.
          output = cat(1,output,temp);
       end
       temp(end) = temp(end) + 1;
       while (One_way_quantum_repeaters.photon_number(temp) > n_constraint)
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