% tic
im_test_name = 'p1_1.bmp';
% db_name = strcat('db', num2str(1),'_*.bmp');
% database = dir(fullfile(folder_dc, db_name));
% 
dc_test_im = read_image(strcat('data\testimages\direction_code\', im_test_name));
canny_test_im = read_image(strcat('data\testimages\canny\', im_test_name));
% 
% dc_db_im = read_image(strcat(database(6).folder, '\', database(6).name));
% canny_db_im = read_image(strcat('data\database\canny\', database(6).name));
% 
% tic
% palmcode_diff_weights_fused_mex(dc_test_im, dc_db_im, canny_test_im, canny_db_im)
% toc

t=1;

for k=6:-1:1
   db_name = strcat('db', num2str(t),'_', num2str(k), '.bmp');
   database_dc(k,1).im = read_image(strcat('data\database\direction_code\', db_name));
   database_canny(k, 1).im = read_image(strcat('data\database\canny\', db_name));
end

%get the score form direct palmcode 
tic
score = direct_palmcode_mex(dc_test_im, canny_test_im, database_dc,database_canny, 6, 1)
toc

scores = report_score_neg(dc_test, dc_db, canny_test, canny_db, im_len, db_len, 3);