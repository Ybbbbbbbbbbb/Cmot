function [Trk,param,Y_set] = MOT_Initialization_Tracklets(rgbimg,Trk,detections,param,Y_set,fr)
%% Copyright (C) 2014 Seung-Hwan Bae
%%
% rgbimg:���ͼƬ
% trk:��Ź켣
% detections:��ż����
% param:���ٲ���
% Y_set:��¼ͼƬ��Ŀ��֮�����õĹ�����
% fr:��ʼ��֡��
%%
%% All rights reserved.

new_thr = param.new_thr;
for i=1:length(Y_set(fr).child)
    prt_idx = Y_set(fr).child{i}; % ��fr֡�е�һ��Ŀ�����һ֡��Ӧ��Ŀ���id
    if length(prt_idx) <= 1
        [child_idx] = mot_search_association(Y_set, fr,prt_idx);% Ѱ�ҵ�ǰĿ����ǰ��ͼ�е�λ��
        
        [ass_idx] = mot_return_ass_idx(child_idx,prt_idx,i,fr); % �γɸ��ٹ켣
    else
        child_idx =[]; tmp_ass_idx =[]; ass_ln=[];
        for j=1:length(prt_idx)
            [child_idx{j}] = mot_search_association(Y_set, fr,prt_idx(j)); 
            [tmp_ass_idx{j}] = mot_return_ass_idx(child_idx{j},prt_idx(j),i,fr);
            ass_ln(j) = length(find(tmp_ass_idx{j} ~= 0));
        end
        [~,pid] = max(ass_ln);
        ass_idx= tmp_ass_idx{pid};
        
    end
    if  length(find(ass_idx ~=0)) >= new_thr  % ���γɵĹ켣���� new_thr���ʱ��˵����ͷ��β�γ���һ�������Ĺ켣
         [Trk,param] = mot_tracklets_components_setup(rgbimg,Trk,detections,fr,ass_idx,param,[]); % �ѹ켣��������������켣�����Ŷȣ�id���ȵ�
        for h=1:length(find(ass_idx ~= 0))
            Y_set(fr-h+1).child{ass_idx(end-h+1)} = 0; % ��ǰ��֡ͼ���еĹ켣��Ϣɾ��
        end
    end
    
end



end