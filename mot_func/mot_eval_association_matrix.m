function [score_mat] = mot_eval_association_matrix(Refer,Test,param,type,ILDA, rgbimg)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
%%
% Refer:轨迹
% Test:检测结果
% param:
% type:类型
% ILDA:线性增强表观模型参数
% 高置信度轨迹与低置信度轨迹通用,轨迹与目标通用
%%

if ILDA.n_update ~= 0
    nproj = size(ILDA.DiscriminativeComponents,2);
else
    nproj = 0;
end

% Association score matrix
score_mat =zeros(length(Refer),length(Test));
for i=1:length(Refer)   %tracking
    
    refer_hist = Refer(i).hist(:)/sum(Refer(i).hist(:));
    refer_h = Refer(i).h;
    refer_w = Refer(i).w;  
    
    
    for j=1:length(Test)  %detection
        
        % Appearance affinity
        test_hist = Test(j).hist(:)/sum(Test(j).hist(:));
        
        if (param.use_ILDA) && (ILDA.n_update ~= 0) && (nproj >2)
            proj = ILDA.DiscriminativeComponents;
            
            refer_feat = proj'*refer_hist;
            test_feat = proj'*test_hist;
            app_sim = dot(refer_feat, test_feat)/(norm(refer_feat) * norm(test_feat));
        else
            app_sim = mot_color_similarity(refer_hist,test_hist);
        end
        
        % Motion affinity
        [mot_sim] =  mot_motion_similarity(Refer(i), Test(j), param, type);
        
        % Shape affinity
        test_h = Test(j).h;
        test_w = Test(j).w;
        shp_sim = mot_shape_similarity(refer_h, refer_w, test_h, test_w);
        
        score_mat(i,j) = mot_sim*app_sim*mot_sim;
    end
end

end


