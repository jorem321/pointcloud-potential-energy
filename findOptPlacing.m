function [ matches, pivot1, pivot2, angle ] = findOptPlacing( X, Y, delta )

%   This is algorithm 2 in the paper.

    M=size(X,1);
    N=size(Y,1);    
    
    % The following are sliced variables in order to be able to parallelize
    % the loops.
    
    VectorMatches = zeros(M,1);
    VectorPivots2 = zeros(M,1);
    VectorAngles = zeros(M,1);
    
    for p = 1:M
        
        Xp = X - X(p,:);
        XpNormsSq = diag(Xp*Xp'); 
        XpNormsSqMatrix = repmat(XpNormsSq, 1, N); %Clone horizontally
        XpAnglesMatrix = repmat(atan2(Xp(:,2), Xp(:,1)), 1, N);

        for q = 1:N
            
            Yq = Y - Y(q,:);
            YqNormsSq = diag(Yq*Yq')';
            YqNormsSqMatrix = repmat(YqNormsSq, M,1); %Clone vertically            
            YqAnglesMatrix = repmat(atan2(Yq(:,2), Yq(:,1))', M, 1); 
            % NOTE: atan2 takes values in the order (y,x), not (x,y)

            % Calculate the semiapertures. By taking the real part and then
            % eliminating all of the zero semiapertures , we discard the 
            % undesirable cases where arccos doesn't exist in the real 
            % numbers, since in this case the result is purely imaginary.     
            
            SemiApertureMatrix = real(acos((XpNormsSqMatrix + YqNormsSqMatrix - delta^2)./(2*sqrt(XpNormsSqMatrix.*YqNormsSqMatrix))));
            SemiApertures = SemiApertureMatrix(:);
            NonZeroPositions = find(SemiApertures);
            SemiApertures = SemiApertures(NonZeroPositions);
            
            XpAngles = XpAnglesMatrix(:);
            XpAngles = XpAngles(NonZeroPositions);
            
            YqAngles = YqAnglesMatrix(:);
            YqAngles = YqAngles(NonZeroPositions);
            
            SecondAngles = mod(XpAngles-YqAngles + SemiApertures, 2*pi);
            FirstAngles = mod(XpAngles-YqAngles - SemiApertures, 2*pi);       
            
            % Let us calculate the initial condition for the interval
            % problem: how many intervals contain 0 as an interior point?
            % R/ All that satisfy SecondAngles<FirstAngles
            
            v=SecondAngles-FirstAngles;
            i=sum(v<0);
            
            %Now we sort the intervals. Here begins algorithm 1 from paper.
            
            EntryAngles = [FirstAngles ones(size(SecondAngles))];
            ExitAngles = [SecondAngles -ones(size(SecondAngles))];
            
            TaggedAngles = sortrows([ExitAngles; EntryAngles]);
            
            TaggedAngles(:,2) = cumsum(TaggedAngles(:,2));
            
            [Matches, place] = max(TaggedAngles(:,2));
            Matches = Matches + i;            
                    
            if(Matches>VectorMatches(p))
                    VectorMatches(p) = Matches;
                    VectorPivots2(p) = q;
                    
                    if(place<length(TaggedAngles))              
                        VectorAngles(p) = (TaggedAngles(place,1)+TaggedAngles(place+1,1))/2;
                    else
                        VectorAngles(p) = (TaggedAngles(place,1)+TaggedAngles(1,1)+2*pi)/2;
                    end
            end
            
            %End of algorithm 1 from paper.
                      
        end
        
        %notif = ['Scanned point ',num2str(p), ' of ' num2str(M), ' in cloud 1.'];
        %disp(notif)
        
    end
    
    [matches,pivot1]=max(VectorMatches);
    pivot2=VectorPivots2(pivot1);
    angle=VectorAngles(pivot1);
    
end