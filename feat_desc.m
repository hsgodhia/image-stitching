% img = double (height)x(width) array (grayscale image) with values in the
% range 0-255
% x = nx1 vector representing the column coordinates of corners
% y = nx1 vector representing the row coordinates of corners
% descs = 64xn matrix of double values with column i being the 64 dimensional
% descriptor computed at location (xi, yi) in im

function [descs] = feat_desc(img, x, y)
    [nr, nc] = size(img);
    descs = zeros(64, numel(x));
    Gx = normpdf([-2:1:2], 0, 1);
    Gy = normpdf([-2:1:2], 0, 1)';    
    for i = 1:numel(x)
        if i == 26 || i == 32 || i == 75 || i == 82
            lp = 1;
        end
        ptx = y(i);
        pty = x(i);
        
        window = zeros(40, 40);
        a_in = 1;
        for ai = (ptx - 19):(ptx + 20)
            b_in = 1;
            for bi = (pty - 19):(pty + 20)
                if ai < 1 || bi < 1 || ai > nr || bi > nc
                    b_in = b_in + 1;
                    continue;
                end
                window(a_in, b_in) = img(ai, bi);
                b_in = b_in + 1;
            end
            a_in = a_in + 1;
        end
        
        %blu_win = imfilter(window, fspecial('gaussian'), 'same');
        blu_win = conv2(conv2(window, Gx, 'same'), Gy, 'same');
        final_win = zeros(8,8);
        down_win = zeros(8, 40);
        for j = 1:8%row sampling
            down_win(j, :) = blu_win(5*j,:);
        end
        for k = 1:8%column sampling
            final_win(:, k) = down_win(:, 5*k);
        end
        %sub_win = blu_win(1:5:40, 1:5:40);
        final_win = final_win(:);
        descs(:,i) = ( final_win - mean(final_win) ) ./ std(final_win);
    end
end