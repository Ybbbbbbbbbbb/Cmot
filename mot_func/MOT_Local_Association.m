function [Trk, Obs_grap, Obs_info] = MOT_Local_Association(Trk, detections, Obs_grap, param, ILDA, fr, rgbimg)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
%%
% Trk:轨迹信息
% detections:目标检测结果
% Obs_grap:存储的轨迹信息
% ILDA:是否使用增强外观模型
% fr:第几帧图片
% rgbimg:图片
%%

Z_meas = detections(fr);
ystate = [Z_meas.x, Z_meas.y, Z_meas.w, Z_meas.h]';
Obs_grap(fr).iso_idx = ones(size(detections(fr).x));
Obs_info.ystate = []; % ystate代表目标得信息(包括中心点得x y 目标狂得 宽 长)
Obs_info.yhist  =[];
if ~isempty(ystate)
    yhist = mot_appearance_model_generation(rgbimg, param, ystate); % 
    Obs_info.ystate = ystate;
    Obs_info.yhist = yhist;
    
    tidx = Idx2Types(Trk,'High'); % 统计高置信度的轨迹存放在tidx(tidx中存放的数字可能就是轨迹的id)
    yidx = find(Obs_grap(fr).iso_idx == 1); % 检测到目标出现的索引
    
    
    if ~isempty(tidx) && ~isempty(yidx)
        Trk_high =[]; Z_set =[];
        
        trk_label = [];
        conf_set = [];
        % For tracklet with high confidence / Length, Occlusion, Affinity
        for ii=1:length(tidx)     
            i = tidx(ii);
            Trk_high(ii).hist = Trk(i).A_Model;
            Trk_high(ii).FMotion = Trk(i).FMotion;
            Trk_high(ii).last_update = Trk(i).last_update;
            
            Trk_high(ii).h = Trk(i).state{end}(4);
            Trk_high(ii).w = Trk(i).state{end}(3);
            Trk_high(ii).type = Trk(i).type;
            trk_label(ii) = Trk(i).label;
            conf_set = [conf_set,  Trk(i).Conf_prob];
        end
        
        % For detections
        meas_label = [];
        for jj=1:length(yidx)
            j = yidx(jj);
            Z_set(jj).hist = yhist(:,:,j);% 第j个目标的颜色直方图
            Z_set(jj).pos = [ystate(1,j);ystate(2,j)];% 目标中心的x， y坐标
            Z_set(jj).h =  ystate(4,j);% 目标得长
            Z_set(jj).w = ystate(3,j);% 目标的宽
            meas_label(jj) = j;% 目标存储的id
        end
        
        thr = param.obs_thr;
        
        
        %score_mat为轨迹与当前帧所有目标中的评估函数
        [score_mat] = mot_eval_association_matrix(Trk_high, Z_set, param, 'Obs', ILDA);  % Trk_high: reliable tracklets, Z_set: detection results
        [matching, ~] = mot_association_hungarian(score_mat, thr);                       % hungarian solver.
        
        % Data association
        if ~isempty(matching)
            for i=1:size(matching,1)
                ass_idx_row = matching(i,1);
                ta_idx = tidx(ass_idx_row);
                ass_idx_col = matching(i,2);
                ya_idx = yidx(ass_idx_col);
                Trk(ta_idx).hyp.score(fr) = score_mat(matching(i,1),matching(i,2));
                Trk(ta_idx).hyp.ystate{fr} =  ystate(:,ya_idx);
                Trk(ta_idx).hyp.new_tmpl = yhist(:,:,ya_idx);
                Trk(ta_idx).last_update = fr;
                Obs_grap(fr).iso_idx(ya_idx) = 0; %
                
            end
        end
    end
end
end