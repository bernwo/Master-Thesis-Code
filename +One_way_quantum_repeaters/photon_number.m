function output = photon_number(treevector)
    % Returns the number of photons of a given treevector including the
    % root photon.
    % E.g. photon_number([2 2 2]) returns 15.
    % E.g. photon_number([4 14 4]) returns 285.
    l = length(treevector);
    temp_sum = 0;
    for i = 1:l
        temp_prod = 1;
        current_treevector = treevector(1:i);
        for j = 1:length(current_treevector)
            temp_prod = temp_prod * current_treevector(j);
        end
        temp_sum = temp_sum + temp_prod;
    end
    output = temp_sum; % This line means excluding the root qubit as photon.
%     output = temp_sum + 1; % This line means including the root qubit as photon.
end