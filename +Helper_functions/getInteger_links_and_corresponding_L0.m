function [n,L0] = getInteger_links_and_corresponding_L0(min_L0,max_L0,steps,L,ctot)
% Returns valid n (# of tree-level links) for a given L (total distance)
% and ctot (total # of [[5,1,3]]-level corrections).
% Also returns the corresponding L0 (inter-repeater distance).
% This function is useful for generating L0 which results in nicely
% dividable # of links, which means this is suitable for use with the
% RECURSIVE model.
dL0=((max_L0-min_L0)/(steps-1));

% Derivation
% ----------
% Ltot == L0*ntot, where ntot=n*c and n is the number of links between two
% consecutive type II stations and c is the number of type II stations.
% Rearranging 'Ltot == L0*ntot' yields 'n == Ltot/(c*L0)'.
% Rearranging 'Ltot == L0*ntot' yields 'L0 == Ltot/(c*n)'.

n = flip( unique(arrayfun(@(in_L0) floor(L/(ctot*in_L0)) , (min_L0):dL0:(max_L0-dL0) )));
n(n==0) = [];

L0 = L./(n*ctot);

end
