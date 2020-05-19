clc;
clear all;

system('run_blisk_py.py'); % Run CalculiX analysis. Comment this line if CalculiX solution exists. 

% Geometry
ri = 100; % Inner radius. [mm]
re = 400; % Outer radius. [mm]

beta = ri/re;

% Material Properties
Ee = 2.1E5; % Elasticity modulus. [MPa]
nu = 0.3; % Poisson's ratio.
gamma = 7.8E-9; % Density. [Ns^2/mm^4]
w = 188.495559; % Angular velocity. [rad/s]


load_calculix_data; % Load data from CalculiX.
cr = (path+ri)/re;  % Dimensionless path in CalculiX.
cpd = length(cr); % Calculix path division.

sb = 8/( (3+nu)*gamma*w^2*re^2 ); % Dimensionless stress multiplier.
ub = 8*Ee/( (3+nu)*(1-nu)*gamma*w^2*re^3 ); % Dimensionless displacement multiplier.

% Loading
sigma_re = 25.3;
sigma_zero = gamma*w^2*re^2;

%
apd = 300; % Analytical calculation path division.

pinc = (re-ri)/apd; % Increment on path.

ar = ri:pinc:re; % Points on path in analytical calculation.
rho = ar/re;

asr = zeros(1,apd+1); % Initialize radial stresses along dimensionless path.
ast = zeros(1,apd+1); % Initialize hoop stresses along dimensionless path.
aur = zeros(1,apd+1); % Initialize displacements along dimensionless path.


i = 1; % loop iteration counter.

while i <= apd+1
    
    asr(1,i) = sigma_re*( 1/(1-beta^2) )*(1 - beta^2/rho(i)^2 ) + ( (3+nu)/8 )*sigma_zero*( 1 + beta^2 - ( beta^2/rho(i)^2 ) - rho(i)^2);
    ast(1,i) = sigma_re*( 1/(1-beta^2) )*(1 + beta^2/rho(i)^2 ) + ( (3+nu)/8 )*sigma_zero*( 1 + beta^2 + ( beta^2/rho(i)^2 ) - ( (1+3*nu)/(3+nu) )*rho(i)^2);
    aur(1,i) = sigma_re*(re/Ee)*(rho(i)/(1-beta^2))*( (1-nu)+(1+nu)*(beta^2/rho(i)^2) ) + (re/Ee)*rho(i)*( (3+nu)/8 )*sigma_zero*( (1+beta^2)*(1-nu) + (1+nu)*(beta^2/rho(i)^2) - rho(i)^2*( (1-nu^2)/(3+nu) ) );
    
    i=i+1; % Increment the counter for the next point on the dimensionless path.
end


% Plot results to an image file.
figure1 = figure('Position', get(0, 'Screensize'));
set(figure1, 'Visible', 'off');
plot(rho,asr,'Color','cyan','LineWidth',2, 'Color','g'); hold on;
plot(rho,ast,'Color','red','LineWidth',2, 'Color','b'); hold on;

l = legend('${\sigma_{r}}$', '${\sigma_{t}}$');
set(l, 'interpreter', 'latex')
set(l,'FontSize',17);

xlim([beta 1]);
ttl = title({'Solution: The Theory of Elasticity', ; 'Radial and Hoop Stresses'}, 'interpreter', 'latex', 'FontSize', 20); 
xlabel('$r/r_{e}$','Interpreter','latex', 'FontSize', 20);
ylh = ylabel('$\sigma$, MPa', 'Interpreter','latex', 'FontSize', 20, 'rotation', 0);
ylh.Position(1) = ylh.Position(1) - 0.05; 
saveas(figure1, 'analytical_solution_stress.png', 'png');

% Plot results to an image file.
figure1 = figure('Position', get(0, 'Screensize'));
set(figure1, 'Visible', 'off');
plot(rho,aur,'Color','cyan','LineWidth',2, 'Color','b'); hold on;
l = legend('${u_{r}}$');
set(l, 'interpreter', 'latex')
set(l,'FontSize',17);

xlim([beta 1]);
ttl = title({'Solution: The Theory of Elasticity', ; 'Radial Displacement'}, 'interpreter', 'latex', 'FontSize', 20);
xlabel('$r/r_{e}$','Interpreter','latex', 'FontSize', 20);
ylh = ylabel('$u_r$, mm', 'Interpreter','latex', 'FontSize', 20, 'rotation', 0);
ylh.Position(1) = ylh.Position(1) - 0.05; 
saveas(figure1, 'analytical_solution_disp.png', 'png');



% Plot results to an image file.
figure1 = figure('Position', get(0, 'Screensize'));

set(figure1, 'Visible', 'off');
plot(rho,asr*sb,'Color','cyan','LineWidth',2); hold on;
plot(rho,ast*sb,'Color','red','LineWidth',2); hold on;
plot(rho,aur*ub,'Color','yellow','LineWidth',2); hold on;

plot(cr,csr*sb,'Color','magenta','LineWidth',2, 'LineStyle', '--'); hold on;
plot(cr,cst*sb,'Color','blue','LineWidth',2, 'LineStyle', '--'); hold on;
plot(cr,cur*ub,'Color','green','LineWidth',2, 'LineStyle', '--');

l = legend('Analytical   ${\bar\sigma_{rr}}$', 'Analytical   ${\bar\sigma_{\theta\theta}}$', 'Analytical   $\bar{u}_{r}$',...
    'CalculiX   ${\bar\sigma_{rr}}$', 'CalculiX   ${\bar\sigma_{\theta\theta}}$', 'CalculiX   $\bar{u}_{r}$');
set(l, 'interpreter', 'latex')
set(l,'FontSize',17);

xlim([beta 1]);
ttl = title({'Blisk: Analytical Solution vs. CalculiX Results'}, 'interpreter', 'latex', 'FontSize', 20);
ttl.Position(2) = ttl.Position(2) + 0.01; 
xlabel('$r/r_{e}$','Interpreter','latex', 'FontSize', 20);
ylh = ylabel({'$\frac{8}{(3+\nu)\rho\omega^2r_e^2)}\sigma$'; '' ;'$\frac{8E}{(3+\nu)(1-\nu)\rho\omega^2r_e^3)}u$'},...
    'Interpreter','latex', 'FontSize', 20, 'rotation', 0);
ylh.Position(1) = ylh.Position(1) - 0.05; 
saveas(figure1, 'blisk_analytical_vs_fe.png', 'png');


% Save analytical results to a file.
results_file = fopen('blisk_analytical_vs_calculix_matlab.txt','w');

fprintf(results_file,"\n");
fprintf(results_file,"*** Blisk: Analytical Solution vs. CalculiX Results ***\n");
fprintf(results_file,"*** CalculiX model combines axisymmetric and plane stress elements. ***\n\n\n");
fprintf(results_file,"\n");

fprintf(results_file,"** Geometry Definition **\n");
fprintf(results_file,"ri/re = %.4f.\n",beta);
fprintf(results_file,"Inner radius:\t\t\ta = %.2f mm.\n",ri);
fprintf(results_file,"Outer radius:\t\t\tb = %.2f mm.\n",re);

fprintf(results_file,"\n");
fprintf(results_file,"** Material Data **\n");
fprintf(results_file,"Elasticity modulus:\t\tE = %.f MPa.\n",Ee);
fprintf(results_file,"Poisson's ratio:\t\tnu = %.2f.\n",nu);
fprintf(results_file,"Density:\t\t\t\tgamma = %.2d Ns^2/mm^4.\n\n",gamma);

fprintf(results_file,"** Load **\n");
fprintf(results_file,"Angular velocity:\t\tw = %.f rad/s.\n\n",w);

fprintf(results_file,"\n");
fprintf(results_file,"** Analytical Solution **\n");
fprintf(results_file,"\n");
fprintf(results_file,"Maximum radial stress is %.f MPa.\n", max(asr));
fprintf(results_file,"Maximum hoop stress is %.f MPa.\n", max(ast));

fprintf(results_file,"\n");
fprintf(results_file,"Radial displacement at the inner radius is %f mm.\n", max(aur(1)));
fprintf(results_file,"Radial displacement at the outer radius is %f mm.\n", max(aur(apd+1)));
fprintf(results_file,"\n");


% Save CalculiX results to a file.
fprintf(results_file,"\n");
fprintf(results_file,"** CalculiX Results **\n");
fprintf(results_file,"\n");
fprintf(results_file,"Maximum radial stress is %.f MPa.\n", max(csr));
fprintf(results_file,"Maximum hoop stress is %.f MPa.\n", max(cst));

fprintf(results_file,"\n");
fprintf(results_file,"Radial displacement at the inner radius is %f mm.\n", max(cur(1)));
fprintf(results_file,"Radial displacement at the outer radius is %f mm.\n", max(cur(cpd)));
fprintf(results_file,"\n\n\n");

fclose(results_file);
