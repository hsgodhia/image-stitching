% descs1 is a 64x(n1) matrix of double values
% descs2 is a 64x(n2) matrix of double values
% match is n1x1 vector of integers where m(i) points to the index of the
% descriptor in p2 that matches with the descriptor p1(:,i).
% If no match is found, m(i) = -1

function [match] = feat_match(descs1, descs2)
    n1 = size(descs1,2);
    n2 = size(descs2,2);
    
    match = zeros(1, n1);
    
    for i=1:n1
        sval = zeros(1, n2);
        a = descs1(:,i);
        for j=1:n2
            b = descs2(:,j);
            ssd = sum((a - b).^2);
            sval(j) = ssd;
        end
        [sval, sind] = sort(sval);
        if sval(1)/sval(2) <= 0.6
            match(i) = sind(1);
        else
            match(i) = -1;
        end
    end
end