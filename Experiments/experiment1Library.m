%0.25 minutiae/mm2 in a fingerprint
%https://www.researchgate.net/post/what_is_the_number_of_minutiae_in_the_fingerprint_image
% This justifies the 150 points

tolerancia = 0.01;

%We initialize a library of pointclouds, created at random.
    
    X=cell(50,1);

for n=1:50
    
    temp = 2*rand(300,2)-1;
    temp = temp(find(diag(temp*temp')<=1),:);
    temp = temp(1:150,:);
    
    X{n} = temp;
    
end

%Here we will store the results of the match we will find.
cloudFound = zeros(50,1);
matchesFound = zeros(50,1);
anglesFound = zeros(50,1);
correctMatch = false(50,1);
expResult = false(50,1);

%Now we begin the experiment, taking a subset from a random element of the library, rotating it by a random angle and adding noise

phi = rand(50,1)*2*pi;
cloudSize = randi([75,150],50,1);
cloudChosen = randi([1,50],50,1);

for n=1:50
    
    tic
    
    R = [cos(-phi(n)), -sin(-phi(n)); sin(-phi(n)), cos(-phi(n))];
    
    set = X{cloudChosen(n)};
    
    %Resort set and make it a subset
    I = rand(150,1);
    [~,I] = sort(I);
    set = set(I,:);
    set = set(1:cloudSize(n),:);
    
    %Rotate set by random angle
    set = set*R';
    
    %Add noise
    E = normrnd(0,0.02,cloudSize(n),2);
    set = set + E;
    
    %Begin matching with clouds in library
    
    matches = zeros(50,1);
    angles = zeros(50,1);
    
    parfor k=1:50
        
        [ matches(k), ~, ~, angles(k)] = findOptPlacing(X{k},set,0.01);

    end
        
    [matchesFound(n), cloudFound(n)]= max(matches);
    anglesFound(n)=angles(cloudFound(n));
    
    %Verifying if the registration was done to the correct pointcloud
    
    if cloudChosen(n) == cloudFound(n)
        correctMatch(n)=true;
        if abs(anglesFound(n)-phi(n))<2*pi/360
            expResult(n)=true;
        end
    end
    
    aviso = ['Terminada iteración  ',num2str(n), ' de ' num2str(50), '.'];
    disp(aviso)
    
    toc
   
end

save('resultsExperiment1');