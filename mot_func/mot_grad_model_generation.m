function [grad_hist] = mot_grad_model_generation(img,param, state)
% ����ת��Ϊ�Ҷ�ͼ
img = rgb2gray(img);
% ��ͼ����ݶ�����
sobel = fspecial('sobel');
sobel_x = imfilter(img, sobel);
sobel_y = imfilter(img, sobel');
image_sobel = sqrt(im2double(sobel_y.^2) + im2double(sobel_x.^2));
image_sobel = image_sobel ./ double(max(max(image_sobel)));
%%
img_templ = mot_generate_temp(image_sobel, state, param.tmplsize);

% ��Ŀ�����Ŀ
Nd = size(state, 2);
img_templ = reshape(img_templ, param.subvec, param.subregion, Nd);
grad_hist = [];
for i=1:Nd
    max_val = max(max(img_templ(:,:,i)));
    cb_temp = img_templ(:,:,i) / max_val * param.Bin;
    cb_temp_hist = (hist(cb_temp, param.Bin) / param.subvec)';
    grad_hist = [grad_hist, cb_temp_hist];
end
end