% Ad-aptive Non-Maximal Suppression
% cimg = corner strength map
% max_pts = number of corners desired
% [x, y] = coordinates of corners
% rmax = suppression radius used to get max_pts corners

function [x, y, rmax] = anms(cimg, max_pts)
    [nr, nc] = size(cimg);    
    
    xs = meshgrid(1:nr, 1:nc)';
    ys = meshgrid(1:nc, 1:nr);
    
    ptsY = ys(:);
    ptsX = xs(:);
    
    maxv = max(cimg(:));
    rvals = size(numel(ptsX), 1);
    for i = 1:nr
        for j = 1:nc
            if cimg(i,j) < maxv*0.01
                continue;
            end
            radi = 1;
            while 1
                if radi > nr || radi > nc
                    radi = radi - 1;
                    break;
                end
                r_lb = max(i - radi, 1);
                r_ub = min(i + radi, nr);
                
                c_lb = max(j - radi, 1);
                c_ub = min(j + radi, nc);
                
                cimg_sub = cimg(r_lb:r_ub, c_lb:c_ub);
                
                subxs = xs(r_lb:r_ub, c_lb:c_ub);
                subys = ys(r_lb:r_ub, c_lb:c_ub);     
                
                ipos = subxs == i;
                jpos = subys == j;
                
                loc = ipos.*jpos;
                loc = ~loc;
                
                dist = sqrt((subxs - i).^2 + (subys - j).^2) <= radi;
                dist = dist.*loc;
                
                cimg_sub = cimg_sub.*dist;
                
                if nnz(cimg_sub >= cimg(i, j)) > 0
                    radi = radi - 1;
                    break;
                else
                    radi = radi + 1;
                end
            end
            rvals((j - 1)*nr + i, :) = radi;
            ptsX((j - 1)*nr + i, :) = i;
            ptsY((j - 1)*nr + i, :) = j;
        end
    end
    [rvals, sind] = sort(rvals, 'descend');

    cx = ptsX(sind, :);
    cx = cx(1:max_pts, :);
    
    cy = ptsY(sind, :);
    cy = cy(1:max_pts, :);
    
    rmax = rvals(1:max_pts,:);
    
    last_r = rmax(max_pts);
    last_prev = rmax(max_pts - 1);
    
    if last_r == last_prev
        en = max_pts - 2;
        while rmax(en) == last_r && en >= 1
            en = en - 1;
        end
        rmax = rmax(1:en);
    end
    x = cy;
    y = cx;
    rmax = min(rmax);
end