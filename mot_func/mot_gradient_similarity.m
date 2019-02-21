function [grad_sim] = mot_gradient_similarity(refer_hist,test_hist)
bhattcoeff = sum(sqrt(refer_hist.*test_hist)); 
if bhattcoeff >1
    [~,p] = corrcoef(refer_hist,test_hist);
    grad_sim = p(1,2);
else
    grad_sim = mean(bhattcoeff);
end
end