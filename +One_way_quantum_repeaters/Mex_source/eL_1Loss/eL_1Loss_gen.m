function output = eL_1Loss_gen(z,t)
	%#codegen
    
    % Derived using logical ket(+) state and qubits lost are [qubit1]
    % with error syndrome 0.
    % The full 9-qubit circuit was used to derive the expression.
	% z is e0.
	% t is etrans.
    
	output = 0;
    coder.cinclude('eL_1Loss.h');
    output = coder.ceval('eL_1Loss', z, t);
end