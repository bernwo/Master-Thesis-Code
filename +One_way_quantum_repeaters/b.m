function output = b(i,d)
    % Params
    % ------
    %   i: Integer
    %       Starts from 0.
    %   d: Integer
    if i <= d
        output = sym("b"+num2str(i),'positive');
    else
        output = 0; 
    end
end