%Notice that this experiment already accounts for outliers.

range = [2:20 2*(11:20) 4*(11:20) 10*(9:15)];
I = length(range);
phi=rand(20,I)*2*pi;

%Here we will store the results of the match we will find.
expSuccesses = zeros(I,1);
angleFound = zeros(20,I);

parfor i=1:I
    
    tic
    
    for k=1:20
        
        R = [cos(-phi(k,i)), -sin(-phi(k,i)); sin(-phi(k,i)), cos(-phi(k,i))];

        S = 2*rand(800,2)-1;
        S = S(find(diag(S*S')<=1),:);
    
        X = S(1:150,:);
        
        %Define and rotate Y
        Y = S(150+1-range(i):150+150-range(i),:)*R'
        
        %Add noise to Y
        E = normrnd(0,0.01,size(Y,1),2);
        Y = Y + E;
        
        %Attempt to match the point clouds
        [ ~, ~, ~, angleFound(k,i)] = findOptPlacing(X,Y,0.01);
        
        if abs(angleFound(k,i)-phi(k,i)) < 2*pi/360
            expSuccesses(i) = expSuccesses(i)+1;
        end
                
    end
    
    disp(['Terminado análisis para tamaño número=  ',num2str(i), '.'])
    
    toc
    
end

save('resultsExperiment2');