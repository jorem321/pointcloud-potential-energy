function [Plot, SubC, Indices ] = findMaxCommonSubcloud( X, Y, p, q, angle, delta )

% Once suitable pivots and the rotation angle are found, this algorithm obtains the 

R = [cos(angle), -sin(angle); sin(angle), cos(angle)];

M=size(X,1);

Xp = X - X(p,:);
Yq = (Y - Y(q,:))*R';

SubC = zeros(0,2);
Indices = zeros(0,2);

for i=1:M
    
    j=M+1-i; %Eliminating backwards in order to avoid labeling of points to change during the process.
    
    C = Yq-Xp(j,:);
    DistancesToYq = diag(C*C');
    [minDist,minIndex]=min(DistancesToYq);
   
    if(minDist<=delta)
        SubC = [SubC; Xp(j,:)];
        Indices = [Indices; [j minIndex]];
                
        Xp(j,:) = [];
        Yq(minIndex,:)=[];
        
    end
        
end

Plot = scatter(SubC(:,1), SubC(:,2), 20, 'rs', 'LineWidth', 2)


end

