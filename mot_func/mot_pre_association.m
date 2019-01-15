function [Y] = mot_pre_association(detections,Y,start_frame,end_frame)

%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
% This code is the situation(occur or miss) of detections in these(5) frames.
cur_det = detections(1);
for i=1:length(cur_det.x)
    Y(start_frame).child{i} = 0; % 第一帧图片有几个目标
end


for q=start_frame+1:end_frame
    prev_det = detections(q-1);
    cur_det = detections(q);
    asso_idx = [];
    for i=1:length(cur_det.x) %当前帧中的目标数目
        ovs1 = calc_overlap2(cur_det,prev_det,i); % 计算当前帧第i个目标与前一帧所有目标的重叠面积的比值
        inds1 = find(ovs1 > 0.4); % 找出重叠率大于0.4的
        % ???
        ratio1 = cur_det.h(i)./prev_det.h(inds1);
        inds2 = (min(ratio1, 1./ratio1) > 0.8); 
        
        if ~isempty(inds1(inds2))
            Y(q).child{i} = inds1(inds2);  
        else
            Y(q).child{i} = 0;
        end
        asso_idx = [asso_idx,inds1(inds2)]; % 添加当前帧的目标中与上一帧形成关联的
    end
    Y(q-1).iso_idx(asso_idx) = 0; 
    
end

end