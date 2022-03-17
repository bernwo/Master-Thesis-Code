%%
close all;clear;clc;
legend_content={'\epsilon_r=0.1‰',...
    '\epsilon_r=0.3‰',...
    '\epsilon_r=0.5‰',...
    '\epsilon_r=0.1%'};
%%
import One_way_quantum_repeaters.eta_e
import One_way_quantum_repeaters.r0_inv
import One_way_quantum_repeaters.secretkeyrate_func_NOCONCAT
import One_way_quantum_repeaters.cost_func_NOCONCAT
import One_way_quantum_repeaters.get_constrained_treevectors2
import One_way_quantum_repeaters.nonneg_min
syms L0 positive

d_constraint = 2;
n_constraint = 300;
constrained_treevectors = get_constrained_treevectors2(d_constraint,n_constraint);
dim = size(constrained_treevectors);
len_tree = dim(1);

Latt_val = 20e3;
eta_d_val = 0.95;
tau_ph_val = 1e-9;
tau_cz_val = 10e-9;

L_min = 100e3;
L_max = 10000e3;
L_points = 200;
L_vals = linspace(L_min,L_max,L_points);
er_vals = [1e-4 3e-4 5e-4 1e-3];
L0_search_array = (1:0.05:6).*1e3;

len_L0 = length(L0_search_array);
len_er = length(er_vals);

tic;
disp("Making matlabFunctions...");
eta_e_func = matlabFunction(eta_e(L0,Latt_val,eta_d_val,d_constraint),'vars',{L0,'b0','b1','b2'});
r0_inv_func = matlabFunction(r0_inv(d_constraint,tau_ph_val,tau_cz_val),'vars',{'b0','b1','b2'});
disp("Made matlabFunctions.");
toc; 
%%
tic;

cf_vals_NOCONCAT = zeros(L_points,len_L0,len_er);
tree_arg_NOCONCAT = zeros(L_points,len_L0,len_er);
for L_index = 1:L_points
    for L0_index = 1:len_L0
        for er_index = 1:len_er
            [cf_vals_NOCONCAT(L_index,L0_index,er_index) , tree_arg_NOCONCAT(L_index,L0_index,er_index)] = ...
                nonneg_min(cost_func_NOCONCAT( Latt_val , tau_ph_val , L_vals(L_index) , L0_search_array(L0_index) , er_vals(er_index) , constrained_treevectors(:,1) , constrained_treevectors(:,2) , constrained_treevectors(:,3) , eta_e_func , r0_inv_func ));
        end
    end
end
disp("Optimised cost function values computed!");
toc;
%% Get the indices of the arguments that lead to the optimised cost function values.
[optimised_cf_vals_NOCONCAT , L0_arg_NOCONCAT] = min(cf_vals_NOCONCAT,[],2);
%% Getting the arguments that lead to the optimised secret key rate.
optimised_tree_vals_NOCONCAT = zeros(L_points,len_er,d_constraint+1);
optimised_L0_vals_NOCONCAT = zeros(L_points,len_er);
for L_index = 1:L_points
    for er_index = 1:len_er
        optimised_L0_vals_NOCONCAT(L_index,er_index) = L0_search_array(L0_arg_NOCONCAT(L_index,er_index));
        optimised_tree_vals_NOCONCAT(L_index,er_index,:) = constrained_treevectors(tree_arg_NOCONCAT(L_index,L0_arg_NOCONCAT(L_index,er_index),er_index),:);
    end
end
disp(squeeze(optimised_tree_vals_NOCONCAT(:,4,:))); % display the treevectors.

%% Getting the corresponding secret key rate based on the optimised cost function values.
tic;
optimised_rs_vals_NOCONCAT = zeros(L_points,len_er);
for L_index = 1:L_points
    for er_index = 1:len_er
        optimised_rs_vals_NOCONCAT(L_index,er_index) = secretkeyrate_func_NOCONCAT( L_vals(L_index) , optimised_L0_vals_NOCONCAT(L_index,er_index) , er_vals(er_index) , optimised_tree_vals_NOCONCAT(L_index,er_index,1) , optimised_tree_vals_NOCONCAT(L_index,er_index,2) , optimised_tree_vals_NOCONCAT(L_index,er_index,3) , eta_e_func , r0_inv_func );
    end
end
disp("Corresponding secret key rate computed!");
toc;
%% Plot: Secret key rate vs Total distance
close all;disp("Close all and re-plot figures.");
mypbaspect = [1 0.618 1];
fig_handle = figure('Renderer', 'painters', 'Position', [500 250 650 510]);%274.2998
loglog(L_vals./1e3,optimised_rs_vals_NOCONCAT(:,1),'marker','x','color','black','linewidth',2); hold on;
loglog(L_vals./1e3,optimised_rs_vals_NOCONCAT(:,2),'marker','o','color','blue','linewidth',2); hold on;
loglog(L_vals./1e3,optimised_rs_vals_NOCONCAT(:,3),'marker','o','color','red','linewidth',2); hold on;
loglog(L_vals./1e3,optimised_rs_vals_NOCONCAT(:,4),'marker','s','color','magenta','linewidth',2);

xlabel('L [km]');
ylabel('SKR');
legend(legend_content{:},...
    'location','southwest');
if tau_cz_val == 10e-9
    axis([L_min./1e3,L_max/1e3,1e3,3e6]);
elseif tau_cz_val == 100e-9
    axis([L_min./1e3,L_max/1e3,1e3,5e5])
end

set(gca,'XTick',[100,(L_max/1e3+100)/2,L_max/1e3],'XMinorTick','on','TickLength',[0.0100,0.0250]*4,'PlotBoxAspectRatio',mypbaspect);
grid on;
hold off;
%%
% Plot: Inter-repeater distance vs Total distance
figure
% close all;
plot(L_vals./1e3,optimised_L0_vals_NOCONCAT(:,1)./1e3,'marker','x','color','black','linewidth',2); hold on;
plot(L_vals./1e3,optimised_L0_vals_NOCONCAT(:,2)./1e3,'marker','o','color','blue','linewidth',2); hold on;
plot(L_vals./1e3,optimised_L0_vals_NOCONCAT(:,3)./1e3,'marker','o','color','red','linewidth',2); hold on;
plot(L_vals./1e3,optimised_L0_vals_NOCONCAT(:,4)./1e3,'marker','s','color','magenta','linewidth',2); hold on;

xlabel('L [km]');
ylabel('L_0 [km]');
legend(legend_content{:});
title('p_{trans}=\eta_{e}^{(m+1)}');
grid on;
axis([L_min./1e3 L_max./1e3 1 6])
beep;