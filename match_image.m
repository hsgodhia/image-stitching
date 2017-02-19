%transforms image1 into image2
function [H, cx1m, cy1m, cx2m, cy2m, inlier_ind ] = match_image(img1, img2, num_pts_anms, ransac_thresh)

    grayimg1 = rgb2gray(img1);
    grayimg2 = rgb2gray(img2);

    cimg1 = corner_detector(grayimg1);
    cimg2 = corner_detector(grayimg2);

    figure;
    imshow(imadjust(cimg1));

    figure;
    imshow(imadjust(cimg2));

    [cx1, cy1, rmax1] = anms(cimg1, num_pts_anms);
    [cx2, cy2, rmax2] = anms(cimg2, num_pts_anms);

    desc1 = feat_desc(grayimg1, cx1, cy1);
    desc2 = feat_desc(grayimg2, cx2, cy2);

    match = feat_match(desc1, desc2);
    ind1 = match ~= -1;
    ind2 = match(ind1);

    cx1m = cx1(ind1');
    cy1m = cy1(ind1');

    cx2m = cx2(ind2');
    cy2m = cy2(ind2');
    
    [H, inlier_ind] = ransac_est_homography(cx1m, cy1m, cx2m, cy2m, ransac_thresh);
    
    %anms plot here
    figure;
    imshow(img1);
    hold on;
    plot(cx1, cy1, '*r', 'markers',4);
    
    %outliers and inliers here/post ransac
    figure;
    imshow(img1);
    hold on;
    plot(cx1m(inlier_ind), cy1m(inlier_ind), '*r', 'markers',4);
    cx1m_b = cx1m;
    cx1m_b(inlier_ind) =[];
    cy1m_b = cy1m;
    cy1m_b(inlier_ind) = [];
    hold on;
    plot(cx1m_b, cy1m_b, 'ob', 'markers',4);

    %anms plot here
    figure;
    imshow(img2);
    hold on;
    plot(cx2, cy2, '*r', 'markers',4);
    
    %outliers and inliers here/post ransac
    figure;
    imshow(img2);
    hold on;
    plot(cx2m(inlier_ind), cy2m(inlier_ind), '*r', 'markers',4);
    cx2m_b = cx2m;
    cy2m_b = cy2m;
    cx2m_b(inlier_ind) = [];
    cy2m_b(inlier_ind) = [];
    hold on;
    plot(cx2m_b, cy2m_b, 'ob', 'markers',4);
    
end