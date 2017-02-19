folder_name = './images/sample1/';
fp = dir(strcat(folder_name,'*.jpg'));
num = length(fp);
images  = cell(num, 1);

for i = 1:num
   fname = fp(i).name;
   img = imread(strcat(folder_name,fname));
   images{i} = img;
end

mosaic = mymosaic(images);