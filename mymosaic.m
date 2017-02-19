% img_input is a cell array of color images (HxWx3 uint8 values in the
% range [0,255])
% img_mosaic is the output mosaic

function [img_mosaic] = mymosaic(images)
    num = numel(images);
    mid = ceil(num/2);
    hvals = cell(num,num);
    for i = 1:num
        if i > mid
            [h, cx3m, cy3m, cx2m, cy2m, inlier_ind ] = match_image(images{i}, images{i-1}, 200, 3.5);
            hvals{i, i - 1} = h;

            figure; ax = axes;
            showMatchedFeatures(images{i-1}, images{i},[cx2m cy2m],[cx3m cy3m],'montage','Parent',ax);
            figure; ax = axes;
            showMatchedFeatures(images{i-1}, images{i},[cx2m(inlier_ind) cy2m(inlier_ind)],[cx3m(inlier_ind) cy3m(inlier_ind)],'montage','Parent',ax);

        elseif i < mid
            [h, cx1m, cy1m, cx2m, cy2m, inlier_ind ] = match_image(images{i}, images{i+1}, 200, 3.5);
            hvals{i, i + 1} = h;

            figure; ax = axes;
            showMatchedFeatures(images{i}, images{i+1},[cx1m cy1m],[cx2m cy2m],'montage','Parent',ax);
            figure; ax = axes;
            showMatchedFeatures(images{i}, images{i+1},[cx1m(inlier_ind) cy1m(inlier_ind)],[cx2m(inlier_ind) cy2m(inlier_ind)],'montage','Parent',ax);

        end
    end

    a = mid - 1;
    b = mid + 1;
    alt = 1; %indicates right
    result = images{mid};
    while a >= 1 || b <= num

        if alt == 1
            result = stitch(images{b}, result, hvals{b,mid});
            b = b + 1;
            alt = 0;
        else
            result = stitch(images{a}, result, hvals{a,mid});
            a = a - 1;
            alt = 1;
        end
        figure;
        imshow(result);
    end
    img_mosaic = result;
end