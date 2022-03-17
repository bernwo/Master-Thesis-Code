%%
close all;clear;clc;clearAllMemoizedCaches;
legend_content={'\epsilon_r=0.1‰',...
    '\epsilon_r=0.3‰',...
    '\epsilon_r=0.5‰',...
    '\epsilon_r=0.1%'};
%%
import One_way_quantum_repeaters.eta_e
import One_way_quantum_repeaters.r0_inv
import One_way_quantum_repeaters.secretkeyrate_func_NOCONCAT
import One_way_quantum_repeaters.secretkeyrate_func_NFT
import One_way_quantum_repeaters.cost_func_NOCONCAT
import One_way_quantum_repeaters.cost_func_NFT
import One_way_quantum_repeaters.get_constrained_treevectors2
import One_way_quantum_repeaters.nonneg_min
import Helper_functions.getInteger_links_and_corresponding_L0
syms L0 positive

warning('off','MATLAB:nchoosek:LargeCoefficient');
get_inbetweenlinks = @(c,L,L0) 1./c .* (L./L0);

d_constraint = 2; % Constraint on depth of tree.
n_constraint = 300; % Constraint on number of photons in the tree.
constrained_treevectors = get_constrained_treevectors2(d_constraint,n_constraint);
dim = size(constrained_treevectors);
len_tree = dim(1);

Latt_val = 20e3;
eta_d_val = 0.95;
tau_ph_val = 1e-9;
tau_cz_val = 10e-9;

L_min = 100e3;
L_max = 10000e3;
L_points = 20;
L_vals = logspace(log10(L_min),log10(L_max),L_points);
er_vals = [1e-4 3e-4 5e-4 1e-3]; 
len_er = length(er_vals);
min_L0 = 1e3;
max_L0 = 4e3;
c_search_array = 1:400;
len_c = length(c_search_array);

len_L0 = 35;
L0_search_array = ones(len_L0,L_points,len_c).*11000e3;
for L_index = 1:L_points
    for c_index = 1:len_c
        [~,temp_L0]=getInteger_links_and_corresponding_L0(min_L0,max_L0,len_L0+1,L_vals(L_index),c_search_array(c_index));
        temp_L0(temp_L0<=0) = []; % remove invalid values. Cheap workaround for now.
        for i_temp = 1:length(temp_L0)
            L0_search_array(i_temp,L_index,c_index) = temp_L0(i_temp);
        end
    end
end

tic;
disp("Making matlabFunctions...");
eta_e_func = matlabFunction(eta_e(L0,Latt_val,eta_d_val,d_constraint),'vars',{L0,'b0','b1','b2'});
r0_inv_func = matlabFunction(r0_inv(d_constraint,tau_ph_val,tau_cz_val),'vars',{'b0','b1','b2'});
disp("Made matlabFunctions.");
toc;
beep;
%% Getting minimised positive cost function values.
tic;
if isempty(gcp('nocreate')) % checks if parpool is running.
    parpool;
    pctRunOnAll warning('off','MATLAB:nchoosek:LargeCoefficient');
else
    pctRunOnAll warning('off','MATLAB:nchoosek:LargeCoefficient');
end
cf_vals = zeros(L_points,len_L0,len_c,len_er);
tree_arg = zeros(L_points,len_L0,len_c,len_er);
parfor L_index = 1:L_points
    disp("Now at L_index: "+num2str(L_index)+" out of "+num2str(L_points)+". Time: "+char(datetime('now')));
    for L0_index = 1:len_L0
        for er_index = 1:len_er
            for c_index = 1:len_c
                [cf_vals(L_index,L0_index,c_index,er_index) , tree_arg(L_index,L0_index,c_index,er_index)] = ...
                    nonneg_min(cost_func_NFT( Latt_val , tau_ph_val , L_vals(L_index) , L0_search_array(L0_index,L_index,c_index) , er_index , c_search_array(c_index) , constrained_treevectors(:,1) , constrained_treevectors(:,2) , constrained_treevectors(:,3) , eta_e_func , r0_inv_func , tau_cz_val ));
            end
        end
    end
end
disp("Optimised cost function values computed!");
toc;
beep;
%% Get the indices of the arguments that lead to the optimised cost function values.
[temp_cf_vals , c_arg] = min(cf_vals,[],3);
[optimised_cf_vals , L0_arg] = min(temp_cf_vals,[],2);
beep;
%% Getting the arguments that lead to the optimised secret key rate.
optimised_c_vals = zeros(L_points,len_er);
optimised_tree_vals = zeros(L_points,len_er,d_constraint+1);
optimised_L0_vals = zeros(L_points,len_er);

for L_index = 1:L_points
    for er_index = 1:len_er
        optimised_c_vals(L_index,er_index) = c_search_array(c_arg(L_index,L0_arg(L_index,er_index),er_index));
        optimised_L0_vals(L_index,er_index) = L0_search_array(L0_arg(L_index,er_index),L_index,c_arg(L_index,L0_arg(L_index,er_index),er_index));
        optimised_tree_vals(L_index,er_index,:) = constrained_treevectors(tree_arg(L_index,L0_arg(L_index,er_index),c_arg(L_index,L0_arg(L_index,er_index),er_index),er_index),:);
    end
end
beep;
%% Getting the corresponding secret key rate based on the optimised cost function values.
tic;

optimised_rs_vals = zeros(L_points,len_er);
optimised_ptrans_vals = zeros(L_points,len_er);
optimised_etae_vals = zeros(L_points,len_er);

for L_index = 1:L_points
    for er_index = 1:len_er
        [optimised_ptrans_vals(L_index,er_index),...
         optimised_etae_vals(L_index,er_index),...
         optimised_rs_vals(L_index,er_index)] = One_way_quantum_repeaters.secretkeyrate_func_NFT( L_vals(L_index) , optimised_L0_vals(L_index,er_index) , er_index , optimised_c_vals(L_index,er_index) , optimised_tree_vals(L_index,er_index,1) , optimised_tree_vals(L_index,er_index,2) , optimised_tree_vals(L_index,er_index,3) , eta_e_func , r0_inv_func , tau_cz_val , true );
    end
end
disp("Corresponding secret key rate computed!");
toc;
beep;
%% PLOTTING
disp("Close all plots and re-plot them.");
clear h_leg;
close all;
loglog(L_vals./1e3,optimised_rs_vals(:,1),'marker','x','color','black','linewidth',2,'linestyle','--'); hold on;
loglog(L_vals./1e3,optimised_rs_vals(:,2),'marker','o','color','blue','linewidth',2,'linestyle','--'); hold on;
loglog(L_vals./1e3,optimised_rs_vals(:,3),'marker','o','color','red','linewidth',2,'linestyle','--'); hold on;
loglog(L_vals./1e3,optimised_rs_vals(:,4),'marker','s','color','magenta','linewidth',2,'linestyle','--'); hold on;

xlabel('L [km]');
ylabel('Secret key rate, r_s');
h_leg=legend(legend_content{:});
h_leg.BoxFace.ColorType='truecoloralpha';
h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');

grid on;
axis([L_min./1e3 L_max./1e3 1e3 2e6])

% Plot: Inter-repeater distance vs Total distance
clear h_leg;
figure;
semilogx(L_vals./1e3,optimised_L0_vals(:,1)./1e3,'marker','x','color','black','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_L0_vals(:,2)./1e3,'marker','o','color','blue','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_L0_vals(:,3)./1e3,'marker','o','color','red','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_L0_vals(:,4)./1e3,'marker','s','color','magenta','linewidth',2,'linestyle','--'); hold on;

xlabel('L [km]');
ylabel('L_0 [km]');
h_leg=legend(legend_content{:});
h_leg.BoxFace.ColorType='truecoloralpha';
h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');

grid on;
axis([L_min./1e3 L_max./1e3 0.8 6.2e3/1e3])

% Plot: Number of corrections vs Total distance
clear h_leg;
figure;
loglog(L_vals./1e3,optimised_c_vals(:,1),'marker','x','color','black','linewidth',2,'linestyle','--'); hold on;
loglog(L_vals./1e3,optimised_c_vals(:,2),'marker','o','color','blue','linewidth',2,'linestyle','--'); hold on;
loglog(L_vals./1e3,optimised_c_vals(:,3),'marker','o','color','red','linewidth',2,'linestyle','--'); hold on;
loglog(L_vals./1e3,optimised_c_vals(:,4),'marker','s','color','magenta','linewidth',2,'linestyle','--'); hold on;

xlabel('L [km]');
ylabel('Number of corrections, c');
h_leg=legend(legend_content{:});
h_leg.BoxFace.ColorType='truecoloralpha';
h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');

grid on;

axis([L_min./1e3 L_max./1e3 min(c_search_array) 1000])
% Plot the number tree-level links in between the [[5,1,3]] stations.
clear h_leg;
figure;
semilogx(L_vals./1e3,get_inbetweenlinks(optimised_c_vals(:,1),L_vals',optimised_L0_vals(:,1)),'marker','x','color','black','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,get_inbetweenlinks(optimised_c_vals(:,2),L_vals',optimised_L0_vals(:,2)),'marker','o','color','blue','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,get_inbetweenlinks(optimised_c_vals(:,3),L_vals',optimised_L0_vals(:,3)),'marker','o','color','red','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,get_inbetweenlinks(optimised_c_vals(:,4),L_vals',optimised_L0_vals(:,4)),'marker','s','color','magenta','linewidth',2,'linestyle','--'); hold on;

xlabel('L [km]');
ylabel('Number of tree-level links in between, n');
h_leg=legend(legend_content{:});
h_leg.BoxFace.ColorType='truecoloralpha';
h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');

grid on;
axis([L_min./1e3 L_max./1e3 1 12])
% Plotting eta_e
clear h_leg;
figure;
semilogx(L_vals./1e3,optimised_etae_vals(:,1),'marker','x','color','black','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_etae_vals(:,2),'marker','o','color','blue','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_etae_vals(:,3),'marker','o','color','red','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_etae_vals(:,4),'marker','s','color','magenta','linewidth',2,'linestyle','--'); hold on;

xlabel('L [km]');
ylabel('\eta_e');
h_leg=legend(legend_content{:});
h_leg.BoxFace.ColorType='truecoloralpha';
h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');

grid on;
axis([L_min./1e3 L_max./1e3 0.998 1])
% Plotting ptrans
clear h_leg;
figure;
semilogx(L_vals./1e3,optimised_ptrans_vals(:,1),'marker','x','color','black','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_ptrans_vals(:,2),'marker','o','color','blue','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_ptrans_vals(:,3),'marker','o','color','red','linewidth',2,'linestyle','--'); hold on;
semilogx(L_vals./1e3,optimised_ptrans_vals(:,4),'marker','s','color','magenta','linewidth',2,'linestyle','--'); hold on;

xlabel('L [km]');
ylabel('p_{trans}');
h_leg=legend(legend_content{:});
h_leg.BoxFace.ColorType='truecoloralpha';
h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');

grid on;
axis([L_min./1e3 L_max./1e3 0 1])