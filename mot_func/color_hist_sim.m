function y_colorhist = color_hist_sim(rgbimg, param, ystate)
img = rgb2gray(rgbimg);
len = size(ystate, 2);
[W, H] = size(img);
for i=1:len
    temp_x = ystate(1,i);
    temp_y = ystate(2,i);
    temp_w = ystate(3,i);
    temp_h = ystate(4,i);
    x1 = round(temp_x - temp_w/2);
    x2 = round(temp_x + temp_w/2);
    y1 = round(temp_y - temp_h/2);
    y2 = round(temp_y + temp_h/2);
    if x1 < 0
       x1 = 1;
    end
    if y1 < 0
      y1 = 1;
    end
    if x2 > W
      x2 = W;
    end
    if y2 > H
       y2 = H;
    end
    [counts, ~] = imhist(img(x1:x2, y1:y2), param.Bin);
    y_colorhist(:,i)  = counts;
end
end