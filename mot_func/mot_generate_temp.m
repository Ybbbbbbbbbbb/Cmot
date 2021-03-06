function [tmpl] = mot_generate_temp(img, state, sz)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
%%
% img:ͼƬ��Ϣ
% state:[Center(X), Center(Y), Width, Height]
% sz:?
%
%%

if (nargin < 3)
    sz = size(img);
end
if (size(state,1) == 1)
    state = state(:);
end
N = size(state,2);

% ת������ AFF = (center(x), center(y), width/64, (0,0,0...N), height/width, (0,0,0,...N))
AFF = [state(1,:); state(2,:); state(3,:)/sz(1); zeros(1,N); state(4,:)./state(3,:); zeros(1,N)];
AFF = affparam2mat(AFF);% AFF(x, y, w/64{templsize(1)}, 0, 0, H/64{templsize(1)});
tmpl = warpimg(img, AFF, sz);
tmpl = reshape(tmpl, sz(1)*sz(2), N);