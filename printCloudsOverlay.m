function [  ] = printCloudsOverlay(X, Y, p, q, angle)

R = [cos(angle), -sin(angle); sin(angle), cos(angle)];

C1nueva = X - X(p,:);
C2nueva = (Y - Y(q,:))*R';

scatter(C1nueva(:,1), C1nueva(:,2), 20, 'rs', 'LineWidth', 2)
hold on %Allows superposing the new graphic
scatter(C2nueva(:,1), C2nueva(:,2), 20, 'bd', 'LineWidth', 1)
grid on
hold off

end

