function [ov, ov_n1, ov_n2] = calc_overlap2(cur_det,prev_det,fr)
%%f2 can be an array and f1 should be a scalar.
%%% this will find the overlap between dres1(f1) (only one) and all detection windows in dres2(f2(:))
%%% 计算当前帧第fr个目标与前一帧所有目标间的重叠面积
 %% Calculate overlap
    n2 = length(prev_det.x);
    % cx1为当前帧的中心横坐标 cx2为目标框的宽
    cx1 = cur_det.x(fr);
    cx2 = cur_det.x(fr) + cur_det.w(fr)-1; % -1是什么意思
    % cy1为当前目标框的中心纵坐标，cy2为目标框的长
    cy1 = cur_det.y(fr);
    cy2 = cur_det.y(fr) + cur_det.h(fr)-1;
    % gx1 gy1前一帧的所有目标框的中心坐标， gx2 gy2 为所有目标的框右下角的坐标
    gx1 = prev_det.x;
    gx2 = prev_det.x + prev_det.w-1;
    gy1 = prev_det.y;
    gy2 = prev_det.y + prev_det.h-1;
    
    % 计算目标框的面积
    ca = (cur_det.w(fr)).* (cur_det.h(fr)); % area
    ga = (prev_det.w).* (prev_det.h);
    

    % xx1 yy1是重叠部分左上角的坐标 
    xx1 = max(cx1, gx1);
    yy1 = max(cy1, gy1);
    % xx2 yy2是重叠部分右下角的坐标
    xx2 = min(cx2, gx2);
    yy2 = min(cy2, gy2);
    
    % 求出重叠框的长和宽
    w = xx2 - xx1 + 1;
    h = yy2 - yy1 + 1;
    
    test = (w>0).*(h>0);
    inds = find((w>0).*(h>0));  % 只有两者都大于0的时候发生重叠的情况。
    ov = zeros(1,n2);
    ov_n1 = zeros(1,n2);
    ov_n2 = zeros(1,n2);
    
    inter = w(inds).*h(inds); %% area of overlap 重叠区域
    u = ca + ga(inds) - w(inds).*h(inds); %% area of union
    ov(inds) = inter./u; % intersection/union
    ov_n1(inds) = inter ./ ca; 
    ov_n2(inds) = inter ./ga(inds); 
end





