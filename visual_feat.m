function visual_feat( img, cimg, y, x )
    % visualize corner matrix
    figure;
    imshow(cimg);
    
    % visualize feature detection
    figure;
    imshow(img);
    hold on;
    scatter(x,y, 'r.');
    hold off;
end

