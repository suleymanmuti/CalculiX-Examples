clc;
clear all;


system('run_rotating_disk_axisymmetric_py.py'); % Run CalculiX analysis. Comment this line if CalculiX solution exists. 

Ee = 2.1E5; % Elasticity modulus. [MPa]
nu = 0.3; % Poisson's ratio.
rho = 7.8E-9; % Density. [Ns^2/mm^4]
w = 1466; % Angular velocity. [rad/s]

a = 28; % Inner radius (r_i). [mm]
b = 125; % Outer radius (r_e). [mm]

k = a/b; %a/b.

sb = 8/( (3+nu)*rho*w^2*b^2 ); % Dimensionless stress multiplier.
ub = 8*Ee/( (3+nu)*(1-nu)*rho*w^2*b^3 ); % Dimensionless displacement multiplier.

load_calculix_data; % Load data from CalculiX.
csr = sb*csr; % Dimensionless radial stresses from CalculiX.
cst = sb*cst; % Dimensionless hoop stresses from CalculiX.
cur = ub*cur; % Dimensionless radial displacements from CalculiX.

cr = (path+a)/b;  % Dimensionless path in CalculiX.

cpd = length(csr); % Calculix path division.


apd = 40; % Analytical calculation path division.


pinc = (1-a/b)/apd; % Increment on dimensionless path.

ar = k:pinc:1; % Dimensionless path in analytical calculation.

asr = zeros(1,apd+1); % Initialize dimensionless radial stresses along dimensionless path.
ast = zeros(1,apd+1); % Initialize dimensionless hoop stresses along dimensionless path.
aur = zeros(1,apd+1); % Initialize dimensionless displacements along dimensionless path.


i = 1; % loop iteration counter.

while i <= apd+1
    
    asr(1,i) =  k^2 - ar(i)^2 - k^2/ar(i)^2 + 1;
    ast(1,i) = k^2 - (1+3*nu)/(3+nu)*ar(i)^2 + k^2/ar(i)^2 + 1;
    aur(1,i) = (k^2+1)*ar(i) - (1+nu)/(3+nu)*ar(i)^3 + (1+nu)/(1-nu)*k^2/ar(i);
    
    i=i+1; % Increment the counter for the next point on the dimensionless path.
end


% Plot results to an image file.
figure1 = figure('Position', get(0, 'Screensize'));

set(figure1, 'Visible', 'off');
plot(ar,asr,'Color','cyan','LineWidth',2); hold on;
plot(ar,ast,'Color','red','LineWidth',2); hold on;
plot(ar,aur,'Color','yellow','LineWidth',2); hold on;

plot(cr,csr,'Color','magenta','LineWidth',2, 'LineStyle', '--'); hold on;
plot(cr,cst,'Color','blue','LineWidth',2, 'LineStyle', '--'); hold on;
plot(cr,cur,'Color','green','LineWidth',2, 'LineStyle', '--');

l = legend('Analytical   ${\bar\sigma_{rr}}$', 'Analytical   ${\bar\sigma_{\theta\theta}}$', 'Analytical   $\bar{u}_{r}$',...
    'CalculiX   ${\bar\sigma_{rr}}$', 'CalculiX   ${\bar\sigma_{\theta\theta}}$', 'CalculiX   $\bar{u}_{r}$');
set(l, 'interpreter', 'latex')
set(l,'FontSize',17);

xlim([k 1]);
ttl = title({'Rotating Hollow Disk: Analytical Solution vs. CalculiX Results'}, 'interpreter', 'latex', 'FontSize', 20);
ttl.Position(2) = ttl.Position(2) + 0.01; 
xlabel('$r/$b','Interpreter','latex', 'FontSize', 20);
ylh = ylabel({'$\frac{8}{(3+\nu)\rho\omega^2{r_e}^2)}\sigma$'; '' ;'$\frac{8E}{(3+\nu)(1-\nu)\rho\omega^2{r_e}^3)}u$'},...
    'Interpreter','latex', 'FontSize', 20, 'rotation', 0);
ylh.Position(1) = ylh.Position(1) - 0.05; 
saveas(figure1, 'rotating_disk_analytical_vs_fe.png', 'png');


% Save analytical results to a file.
results_file = fopen('rotating_disk_analytical_vs_calculix_matlab.txt','w');

fprintf(results_file,"\n");
fprintf(results_file,"*** Rotating Hollow Disk: Analytical Solution vs. CalculiX Results ***\n\n\n");
fprintf(results_file,"\n");

fprintf(results_file,"** Geometry Definition **\n");
fprintf(results_file,"a/b = %.4f.\n",k);
fprintf(results_file,"Inner radius:\t\t\ta = %.2f mm.\n",a);
fprintf(results_file,"Outer radius:\t\t\tb = %.2f mm.\n",b);

fprintf(results_file,"\n");
fprintf(results_file,"** Material Data **\n");
fprintf(results_file,"Elasticity modulus:\t\tE = %.f MPa.\n",Ee);
fprintf(results_file,"Poisson's ratio:\t\tnu = %.2f.\n",nu);
fprintf(results_file,"Density:\t\t\t\trho = %.2d Ns^2/mm^4.\n\n",rho);

fprintf(results_file,"** Load **\n");
fprintf(results_file,"Angular velocity:\t\tw = %.f rad/s.\n\n",w);

fprintf(results_file,"\n");
fprintf(results_file,"** Analytical Solution **\n");
fprintf(results_file,"Reference: Rotors: Stress Analysis and Design, 2013, p.29, Example 1.\n");
fprintf(results_file,"\n");
fprintf(results_file,"Maximum radial stress is %.f MPa.\n", max(asr)/sb);
fprintf(results_file,"Minimum radial stress is %.f MPa.\n", min(asr)/sb);
fprintf(results_file,"Maximum hoop stress is %.f MPa.\n", max(ast)/sb);
fprintf(results_file,"Minimum hoop stress is %.f MPa.\n", min(ast)/sb);

fprintf(results_file,"\n");
fprintf(results_file,"Radial displacement at the inner radius is %f mm.\n", max(aur(1))/ub);
fprintf(results_file,"Radial displacement at the outer radius is %f mm.\n", max(aur(apd+1))/ub);
fprintf(results_file,"\n");


% Save CalculiX results to a file.
fprintf(results_file,"\n");
fprintf(results_file,"** CalculiX Results **\n");
fprintf(results_file,"\n");
fprintf(results_file,"Maximum radial stress is %.f MPa.\n", max(csr)/sb);
fprintf(results_file,"Minimum radial stress is %.f MPa.\n", min(csr)/sb);
fprintf(results_file,"Maximum hoop stress is %.f MPa.\n", max(cst)/sb);
fprintf(results_file,"Minimum hoop stress is %.f MPa.\n", min(cst)/sb);

fprintf(results_file,"\n");
fprintf(results_file,"Radial displacement at the inner radius is %f mm.\n", max(cur(1))/ub);
fprintf(results_file,"Radial displacement at the outer radius is %f mm.\n", max(cur(cpd))/ub);
fprintf(results_file,"\n\n\n");

fclose(results_file);

