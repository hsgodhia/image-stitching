% y1, x1, y2, x2 are the corresponding point coordinate vectors Nx1 such
% that (y1i, x1i) matches (x2i, y2i) after a preliminary matching

% thresh is the threshold on distance used to determine if transformed
% points agree

% H is the 3x3 matrix computed in the final step of RANSAC

% inlier_ind is the nx1 vector with indices of points in the arrays x1, y1,
% x2, y2 that were found to be inliers

function [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, thresh)
    nmch = size(x1, 1);
    max_inli_cn = 1;
    for i = 1:1000
        rid = randperm(nmch);
        train = rid(1:4);
        test  = rid(5:end);
        
        x2_train = x2(train);
        y2_train = y2(train);
        x1_train = x1(train);
        y1_train = y1(train);
        
        x2_test = x2(test);
        y2_test = y2(test);
        x1_test = x1(test);
        y1_test = y1(test);
        
        
        H = est_homography(x2_train,y2_train,x1_train,y1_train);
        [ho_x, ho_y] = apply_homography(H, x1_test, y1_test);

        ssd = (ho_x - x2_test).^2 + (ho_y - y2_test).^2;
        in_li = ssd < thresh;
        in_li_cn = nnz(in_li);

        if in_li_cn > max_inli_cn
            inlier_ind = test(in_li);
            max_inli_cn = in_li_cn;
        end
    end
    H = est_homography(x2(inlier_ind),y2(inlier_ind),x1(inlier_ind),y1(inlier_ind));
end