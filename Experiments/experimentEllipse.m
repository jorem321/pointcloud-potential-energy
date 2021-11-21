%More complicated: matching just a part with noise

tolerancia = 0.01;
x = pi*(1:200)'/(100);
phi=2;
R = [cos(-phi), -sin(-phi); sin(-phi), cos(-phi)];

C1 = [3*cos(x) 2*sin(x)];
E = normrnd(0,0.02,200,2);
I = [1:50, 70:110, 140:195]';
C2 = (C1(I, :) + E(I, :))*R';
outliers = normrnd(0,2,50,2);
C2 = [C2; outliers];


[ potMin, pivote1, pivote2, angulo ] = findOptPlacing(C1,C2, 0.01);

figure(1);
printCloudsOverlay (C1, C2, pivote1, pivote2, angulo)

figure(2);
[PlotSubcloud, SubC, Indices] = findMaxCommonSubcloud(C1, C2, pivote1, pivote2, angulo, tolerancia)

figure(3);
printCloudsOverlay(C1,C2,1,1,0)