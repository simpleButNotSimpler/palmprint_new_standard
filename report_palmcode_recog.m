function report_palmcode_recog()

right_dp = zeros(1, 1);
wrong_dp = right_dp;


%parpool
% parpool(4)

for main_counter=1:10
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
       
%        plot(1:numel(dp), dp, 'r*')
       
       %min indexes
       [~, dp_min_idx] = min(dp);
       
       %verdicts
       idx = (dp_min_idx == main_counter);
       right_dp = right_dp + idx;
       wrong_dp = wrong_dp + ~idx;

       if ~idx(1)
          fid = fopen('mismatched_dp.txt', 'a');
          fprintf(fid, '%10s %3d \n', current_im_name, dp_min_idx(1));
          fclose(fid);
       end
    end
 end

%write result to file
fid = fopen('report_palmcode_recog_red.txt', 'w');
fprintf(fid, '%s\n', 'DP (RED)');
fprintf(fid, '%4d %4d\n', [right_dp; wrong_dp]);
fclose(fid);

% delete(gcp('nocreate'))
winopen('report_palmcode_recog_red.txt');
disp('nou fini')
end


function dp = report_score(im_test_name)   
   %test the image against all the database
   dp = zeros(500, 1) + inf;
   
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
       dp(t, :) = direct_palmcode_mex(dc_test_im, canny_test_im, database_dc, database_canny, 6);
   end
end