function [x, y] = change_to_same_size(refer,test)
% 将refer test两个矩阵转化为相同大小的矩阵x，y
[x1, y1] = size(refer);
[x2, y2] = size(test);
final_x = max(x1, x2);
final_y = max(y1, y2);
x = imresize(refer, [final_x, final_y]);
y = imresize(test, [final_x, final_y]);