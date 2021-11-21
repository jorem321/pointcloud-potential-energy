%Simplest experiment: same number of points, presence of noise.

tolerancia = 0.01;
x = pi*(1:200)'/(100);
phi=2;
R = [cos(-phi), -sin(-phi); sin(-phi), cos(-phi)];

C1 = [x sin(x)];
E = normrnd(0,0.01,200,2);
C2 = (C1 + E)*R';

[ potMin, pivote1, pivote2, angulo ] = findOptPlacing(C1,C2, 0.01);

figure(1);
printCloudsOverlay (C1, C2, pivote1, pivote2, angulo)

figure(2);
[PlotSubcloud, SubC, Indices] = findMaxCommonSubcloud(C1, C2, pivote1, pivote2, angulo, tolerancia)

figure(3);
printCloudsOverlay(C1,C2,1,1,0)