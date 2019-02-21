function [Trk] = MOT_State_Update(Trk, param, fr)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
% Update states and models of tracklets
%%
% 更新轨迹得外观模型和运动模型
%%
for i=1:length(Trk)
    if Trk(i).last_update == fr
        alpha = 0.5;
        % color histogram
        new_tmpl = Trk(i).hyp.new_tmpl;
        old_tmpl = Trk(i).A_Model;
        Trk(i).A_Model = (1 - alpha)*old_tmpl + alpha*new_tmpl;
        % gradient
        new_grad = Trk(i).hyp.new_grad;
        old_grad = Trk(i).gradhist;   
        Trk(i).gradhist = (1 - alpha)*new_grad + alpha*new_grad;
        % motion
        ystate = Trk(i).hyp.ystate{fr};
        [Trk(i)] = km_state_update(Trk(i),ystate,param,fr);% 运动模型卡尔曼滤波更新过程
        
    else
        [Trk(i)]= km_state_update(Trk(i), [], param,fr);
    end
end
end
