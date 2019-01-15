function [XX,PP] = mot_motion_model_generation(Trk,param,type)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.

switch type
    case 'Forward'
        Y = cell2mat(Trk.state);
        X(1,:) = Y(1,1); 
        X(2,:) = 0;      
        X(3,:) = Y(2,1); 
        X(4,:) = 0;      
        Y(3:4,:) = []; % 截去目标的 宽 和 高
        Yr = Y;
    case 'Backward'
        Y = cell2mat(Trk.state);
        X(1,:) = Y(1,end); X(2,:) = 0; 
        X(3,:) = Y(2,end); X(4,:) = 0; 
        % 去掉目标框得长和宽
        Y(3:4,:) = [];
        Yr = Y(:,end:-1:1);
        
end
% X(最后一帧目标的x坐标，0，最后一帧的y坐标，0) Yr(从后往前所有帧的x坐标，y坐标)
[XX,PP] = km_state_est(X,Yr,param);


end
