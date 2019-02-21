function [ISO] = mot_pre_association_tracking(init_img_set,ISO,start_frame,end_frame)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
%%
%����ӵ�ǰ֡��ǰ�� param.show_scan ֡��Ŀ��֮���Ԥ��ϵ
%%
for i=start_frame:end_frame
    ISO.node(i).child =[]; 
end

init_det =ISO.meas(start_frame);

for i=1:length(init_det.x)
    ISO.node(start_frame).child{i} = 0;
end

if  ~isempty(init_det.x)
    
    detections = ISO.meas;
    
    for q=start_frame+1:end_frame
        prev_det = detections(q-1);
        cur_det = detections(q);
        prev_img = init_img_set{q-1};
        cur_img = init_img_set{q};
        
        for i=1:length(cur_det.x)
            ISO.node(q).child{i} = 0;
        end
        asso_idx = [];
        for i=1:length(cur_det.x)
%             ���ø��ٽ���������ʼ��
            ovs1 = calc_overlap2(cur_det,prev_det,i);
            inds1 = find(ovs1 > 0.4);
            ratio1 = cur_det.h(i)./prev_det.h(inds1);
            inds2 = (min(ratio1, 1./ratio1) > 0.8);
            if ~isempty(inds1(inds2))
                ISO.node(q).child{i} = inds1(inds2);  
            else
                ISO.node(q).child{i} = 0;
            end
            asso_idx = [asso_idx,inds1(inds2)]; 


%             ����sobel��ŷ�Ͼ����ʼ��
%             pre_index= cal_pre_grad(cur_img, prev_img, cur_det, prev_det, i);
%             ISO.node(q).child{i} = pre_index;
%             asso_idx = [asso_idx, pre_index];
        end
    end
end
end