function [Trk] = km_state_update(Trk,ymeas,param,fr)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
%%
% Trk:轨迹信息
% ymeas:第fr帧目标的信息(center(x), center(y), wdith, height)
% fr:第几帧图片
%%

[size_state] = estimation_size(Trk,ymeas,fr);

XX = Trk.FMotion.X(:,end);
PP = Trk.FMotion.P(:,:,end);

if ~isempty(ymeas)
    [XX,PP] = km_estimation(XX,ymeas(1:2),param,PP);
else
    [XX,PP] = km_estimation(XX,[],param,PP);
end

pos_state = [XX(1);XX(3)];
Trk.state{fr} = [pos_state;size_state];

Trk.FMotion.X(:,fr) = XX;
Trk.FMotion.P(:,:,fr) = PP;