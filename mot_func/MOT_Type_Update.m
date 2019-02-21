function [Trk] = MOT_Type_Update(rgbimg,Trk,type_thr,cfr)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
%%
% 修改轨迹得置信度(以及更新目标得位置)
%%


del_idx = []; lb_idx =[];
max_frame = 50;

for i=1:length(Trk)
    Conf_prob = Trk(i).Conf_prob;
    type = Trk(i).type;
    switch type
        case 'High'
            if Conf_prob < type_thr
                Trk(i).type = 'Low';
                Trk(i).efr = cfr;
            end
        case 'Low'
            if Conf_prob > type_thr
                Trk(i).type = 'High';
            end
            efr = Trk(i).efr;
            if abs(cfr - efr) >= max_frame % 如果轨迹间隔超过max_frame，则视为新轨迹
                del_idx = [del_idx,i];
                lb_idx= [lb_idx, Trk(i).label];
            end
    end
end

[R_pos(2), R_pos(1), ~] = size(rgbimg);
L_pos = [0,0];

% 修改margin边缘，使它适配红外小目标
margin = [0 0];

% margin = [0 -200];
for i=1:length(Trk)
    tstates =Trk(i).state{end};

    if isnan(tstates(1))
        del_idx = [del_idx,i];
    else
         fmotion = Trk(i).state{end};
         C_pos(1) = fmotion(1,end);
         C_pos(2) = fmotion(2,end);
         L_pos = L_pos + margin;
         R_pos = R_pos - margin;
         if ~(mot_is_reg(C_pos,L_pos,R_pos)) % 红外单目标测试得时候这里会变为0
             del_idx = [del_idx,i];
         end
    end
end
    
if ~isempty(del_idx)
    Trk(del_idx) = [];
end


end