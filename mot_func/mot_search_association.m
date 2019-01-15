function [ass_idx] = mot_search_association(Y,fr,prt_idx)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
%%
% 寻找当前帧（第fr）中第prt_idx个目标在前面所有帧中的对应情况
%%


flg = 1;
ct = 0;
ass_idx = [];
if prt_idx ~=0
    while flg == 1
        ct = ct +1;
        prt_idx = Y(fr-ct).child{prt_idx};
        if length(prt_idx) == 1
            if (prt_idx ~=0) && length(prt_idx) ==1
                ass_idx = [prt_idx,ass_idx];
            else
                ass_idx = [prt_idx,ass_idx];
                flg = 0;
            end
        else
            ass_idx = [0,ass_idx];
            flg = 0;
        end
        
    end
end


end