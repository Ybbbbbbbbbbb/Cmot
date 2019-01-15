function [Y] = mot_pre_association(detections,Y,start_frame,end_frame)

%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
% This code is the situation(occur or miss) of detections in these(5) frames.
cur_det = detections(1);
for i=1:length(cur_det.x)
    Y(start_frame).child{i} = 0; % ��һ֡ͼƬ�м���Ŀ��
end


for q=start_frame+1:end_frame
    prev_det = detections(q-1);
    cur_det = detections(q);
    asso_idx = [];
    for i=1:length(cur_det.x) %��ǰ֡�е�Ŀ����Ŀ
        ovs1 = calc_overlap2(cur_det,prev_det,i); % ���㵱ǰ֡��i��Ŀ����ǰһ֡����Ŀ����ص�����ı�ֵ
        inds1 = find(ovs1 > 0.4); % �ҳ��ص��ʴ���0.4��
        % ???
        ratio1 = cur_det.h(i)./prev_det.h(inds1);
        inds2 = (min(ratio1, 1./ratio1) > 0.8); 
        
        if ~isempty(inds1(inds2))
            Y(q).child{i} = inds1(inds2);  
        else
            Y(q).child{i} = 0;
        end
        asso_idx = [asso_idx,inds1(inds2)]; % ��ӵ�ǰ֡��Ŀ��������һ֡�γɹ�����
    end
    Y(q-1).iso_idx(asso_idx) = 0; 
    
end

end