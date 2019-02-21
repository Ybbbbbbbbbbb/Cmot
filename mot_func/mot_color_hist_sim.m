function colorhist_sim = mot_color_hist_sim(img,param,refer,test,type)

img = rgb2gray(img);
[W, H] = size(img);
switch type
    case 'Obs'
        temp_x = test.x;
        temp_y = test.y;
        temp_w = test.w;
        temp_h = test.h;
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
        test_counts = counts / sum(counts);
        refer_colorhist = refer.colorhist / (refer.w * refer.h);
        temp = sum(refer_colorhist);
        colorhist_sim  = exp(-0.5 *(sum(abs(test_counts - refer_colorhist))));
        
    case 'Trk'
        refer_colorhist = refer.colorhist;
        test_colorhist = test.colorhist;
        colorhist_sim = exp(-0.5 * (sum(abs( (refer_colorhist/sum(refer_colorhist) - test_colorhist/sum(test_colorhist))))) );
        
end


end