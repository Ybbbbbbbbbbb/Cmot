function [ov, ov_n1, ov_n2] = calc_overlap2(cur_det,prev_det,fr)
%%f2 can be an array and f1 should be a scalar.
%%% this will find the overlap between dres1(f1) (only one) and all detection windows in dres2(f2(:))
%%% ���㵱ǰ֡��fr��Ŀ����ǰһ֡����Ŀ�����ص����
 %% Calculate overlap
    n2 = length(prev_det.x);
    % cx1Ϊ��ǰ֡�����ĺ����� cx2ΪĿ���Ŀ�
    cx1 = cur_det.x(fr);
    cx2 = cur_det.x(fr) + cur_det.w(fr)-1; % -1��ʲô��˼
    % cy1Ϊ��ǰĿ�������������꣬cy2ΪĿ���ĳ�
    cy1 = cur_det.y(fr);
    cy2 = cur_det.y(fr) + cur_det.h(fr)-1;
    % gx1 gy1ǰһ֡������Ŀ�����������꣬ gx2 gy2 Ϊ����Ŀ��Ŀ����½ǵ�����
    gx1 = prev_det.x;
    gx2 = prev_det.x + prev_det.w-1;
    gy1 = prev_det.y;
    gy2 = prev_det.y + prev_det.h-1;
    
    % ����Ŀ�������
    ca = (cur_det.w(fr)).* (cur_det.h(fr)); % area
    ga = (prev_det.w).* (prev_det.h);
    

    % xx1 yy1���ص��������Ͻǵ����� 
    xx1 = max(cx1, gx1);
    yy1 = max(cy1, gy1);
    % xx2 yy2���ص��������½ǵ�����
    xx2 = min(cx2, gx2);
    yy2 = min(cy2, gy2);
    
    % ����ص���ĳ��Ϳ�
    w = xx2 - xx1 + 1;
    h = yy2 - yy1 + 1;
    
    test = (w>0).*(h>0);
    inds = find((w>0).*(h>0));  % ֻ�����߶�����0��ʱ�����ص��������
    ov = zeros(1,n2);
    ov_n1 = zeros(1,n2);
    ov_n2 = zeros(1,n2);
    
    inter = w(inds).*h(inds); %% area of overlap �ص�����
    u = ca + ga(inds) - w(inds).*h(inds); %% area of union
    ov(inds) = inter./u; % intersection/union
    ov_n1(inds) = inter ./ ca; 
    ov_n2(inds) = inter ./ga(inds); 
end





