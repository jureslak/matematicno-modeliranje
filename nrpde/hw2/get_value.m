function [value] = get_value(alfa, hats, point)
% calculates value of linear combination of hats at a given point
value = zeros(size(point));
for i = 1:length(alfa)
    value = value + alfa(i)*hats{i}(point);
end
end

