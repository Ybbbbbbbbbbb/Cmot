function [score_mat] = mot_eval_association_matrix(Refer,Test,param,type,ILDA, rgbimg)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.
%%
% Refer:�켣
% Test:�����
% param:
% type:����
% ILDA:������ǿ���ģ�Ͳ���
% �����Ŷȹ켣������Ŷȹ켣ͨ��,�켣��Ŀ��ͨ��
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
    refer_grade_hist = Refer(i).gradhist(:);
    refer_h = Refer(i).h;
    refer_w = Refer(i).w;  
%     refer_localimg = Refer(i).localimg;
    
    for j=1:length(Test)  %detection
        
        % Appearance affinity
        test_hist = Test(j).hist(:)/sum(Test(j).hist(:));
        % �ݶ�����������
        test_grad_hist = Test(j).gradhist(:);
        
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
        
        % �ݶ�����
        grad_sim = mot_gradient_similarity(refer_grade_hist,test_grad_hist);
        
        score_mat(i,j) = app_sim * mot_sim * shp_sim * grad_sim;

    end
end

end


