function [mins, idxes] = nonneg_min(array, varargin)
    temp = array;
    temp(temp<0) = nan;
    [mins, idxes] = min(temp, varargin{:});
end