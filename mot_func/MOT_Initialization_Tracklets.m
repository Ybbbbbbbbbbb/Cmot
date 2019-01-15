function [Trk,param,Y_set] = MOT_Initialization_Tracklets(rgbimg,Trk,detections,param,Y_set,fr)
%% Copyright (C) 2014 Seung-Hwan Bae
%%
% rgbimg:存放图片
% trk:存放轨迹
% detections:存放检测结果
% param:跟踪参数
% Y_set:记录图片的目标之间计算好的关联性
% fr:初始化帧数
%%
%% All rights reserved.

new_thr = param.new_thr;
for i=1:length(Y_set(fr).child)
    prt_idx = Y_set(fr).child{i}; % 第fr帧中第一个目标跟上一帧对应的目标的id
    if length(prt_idx) <= 1
        [child_idx] = mot_search_association(Y_set, fr,prt_idx);% 寻找当前目标在前面图中的位置
        
        [ass_idx] = mot_return_ass_idx(child_idx,prt_idx,i,fr); % 形成跟踪轨迹
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
    if  length(find(ass_idx ~=0)) >= new_thr  % 当形成的轨迹数跟 new_thr相等时，说明从头到尾形成了一条完整的轨迹
         [Trk,param] = mot_tracklets_components_setup(rgbimg,Trk,detections,fr,ass_idx,param,[]); % 把轨迹填充完整，包括轨迹的置信度，id，等等
        for h=1:length(find(ass_idx ~= 0))
            Y_set(fr-h+1).child{ass_idx(end-h+1)} = 0; % 把前几帧图像中的轨迹信息删除
        end
    end
    
end



end