function report_palmcode_recog()

right_dp = zeros(1, 1);
wrong_dp = right_dp;

right_dp3 = right_dp;
wrong_dp3 = right_dp;

right_dp4 = right_dp;
wrong_dp4 = right_dp;

%parpool
% parpool(4)

parfor main_counter=1:500
    disp(num2str(main_counter))
    im_prefix = strcat('p', num2str(main_counter), '_*.bmp');
    
    testim = dir(fullfile('data\testimages\cleaned', im_prefix));
    if isempty(testim)
       continue
    end
    
    %recognition
    for t=1:numel(testim)
       current_im_name = testim(t).name;
        
       %get class (1xN array), same size as error
       [dp] = report_score(current_im_name);
       
%      plot(1:numel(dp), dp, 'r*')
       
       %min indexes
       [~, dp_min_idx] = min(dp(:, 1));
       [~, dp_min_idx3] = min(dp(:, 2));
       [~, dp_min_idx4] = min(dp(:, 3));
       
       %verdicts
       %1
       idx = (dp_min_idx == main_counter);
       right_dp = right_dp + idx;
       wrong_dp = wrong_dp + ~idx;
       
       %3
       idx = (dp_min_idx3 == main_counter);
       right_dp3 = right_dp3 + idx;
       wrong_dp3 = wrong_dp3 + ~idx;
       
       %4
       idx = (dp_min_idx4 == main_counter);
       right_dp4 = right_dp4 + idx;
       wrong_dp4 = wrong_dp4 + ~idx;
    end
 end

%write result to file
fid = fopen('report_palmcode_recog_red.txt', 'w');
fprintf(fid, '%s \n%s \n', 'DP (RED)', 'bias: 1');
fprintf(fid, '%4d %4d\n', [right_dp; wrong_dp]);

fprintf(fid, '%s \n', 'bias: 3');
fprintf(fid, '%4d %4d\n', [right_dp3; wrong_dp3]);

fprintf(fid, '%s \n', 'bias: 4');
fprintf(fid, '%4d %4d\n', [right_dp4; wrong_dp4]);
fclose(fid);

% delete(gcp('nocreate'))
winopen('report_palmcode_recog_red.txt');
disp('nou fini')
end


function dp = report_score(im_test_name)   
   %test the image against all the database
   dp = zeros(500, 3) + inf;
   
   dc_test_im = read_image(strcat('data\testimages\direction_code\', im_test_name));
   canny_test_im = read_image(strcat('data\testimages\canny\', im_test_name));
   
   for t=1:500
       %struct containing dc and canny images
       db_len = 6;
       for k=db_len:-1:1
           db_name = strcat('db', num2str(t),'_', num2str(k), '.bmp');
           database_dc(k,1).im = read_image(strcat('data\database\direction_code\', db_name));
           database_canny(k,1).im = read_image(strcat('data\database\canny\', db_name));
       end
       
       %get the score form direct palmcode
       dp(t, 1) = direct_palmcode_mex(dc_test_im, canny_test_im, database_dc, database_canny, 6, 1);
       dp(t, 2) = direct_palmcode_mex(dc_test_im, canny_test_im, database_dc, database_canny, 6, 3);
       dp(t, 3) = direct_palmcode_mex(dc_test_im, canny_test_im, database_dc, database_canny, 6, 4);
   end
end