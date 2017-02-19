%stitching starts here,
%lets say we first transform all points of img1 to img2, so it is in
%img2's frame

function [stitch_img] = stitch(img1, img2, H)

[nr1, nc1] = size(img1(:,:,1));
xs1 = [1 nc1 nc1 1];
ys1 = [1 1 nr1 nr1];

[nr2, nc2] = size(img2(:,:,1));
xs2 = [1 nc2 nc2 1];
ys2 = [1 1 nr2 nr2];

%move the points in image 1 into image 2
[ho_x1, ho_y1] = apply_homography(H, xs1', ys1');
hox_max = round(max(ho_x1));
hox_min = round(min(ho_x1));

hoy_max = round(max(ho_y1));
hoy_min = round(min(ho_y1));
nc1_new = hox_max - hox_min + 1;
nr1_new = hoy_max - hoy_min + 1;

big_xmin = min(hox_min, min(xs2));
big_xmax = max(hox_max, max(xs2));

big_ymin = min(hoy_min, min(ys2));
big_ymax = max(hoy_max, max(ys2));

big_nc = big_xmax - big_xmin + 1;
big_nr = big_ymax - big_ymin + 1;

new_img = zeros(big_nr, big_nc, 3);
temp = zeros(nr1_new, nc1_new, 3);

%paste image1 into the big box
bxoff = big_xmin - 1;
byoff = big_ymin - 1;

for i = big_xmin:big_xmax
    for j = big_ymin:big_ymax
        px = i - bxoff;
        py = j - byoff;
        if i < 1 || j < 1 || i > nc2 || j > nr2
            continue;
        else
            new_img(py, px, 1) = img2(j, i, 1);
            new_img(py, px, 2) = img2(j, i, 2);
            new_img(py, px, 3) = img2(j, i, 3);
        end
    end
end

for i = big_xmin:big_xmax
    for j = big_ymin:big_ymax
        px = i - bxoff;
        %py = j - byoff + (big_nr - (hoy_max - hoy_min + 1));
        if max(nr2, nr1_new) == nr2
            sub = round(ho_y1(1));
        else
            sub = 0;
        end
        py = j - byoff + (big_nr - max(nr1_new, nr2)) + sub;
        [a,b] = apply_homography(inv(H), i, j);
        if a < 1 || b < 1 || a > nc1 || b > nr1 || px < 1|| py < 1
            continue;
        else
            b = round(b);
            a = round(a);

            new_img(py, px, 1) = img1(b, a, 1);
            new_img(py, px, 2) = img1(b, a, 2);
            new_img(py, px, 3) = img1(b, a, 3);
        end
    end
end

stitch_img = uint8(new_img);
end