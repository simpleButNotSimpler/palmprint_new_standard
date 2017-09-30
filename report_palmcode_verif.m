function report_palmcode_verif()

n1 = zeros(1, 23);
n2 = n1;
n3 = n1;
n4 = n1;
total_pos = 0;
total_neg = 0;

error = [0 0.05 0.1 0.15 0.2 0.25 0.255 0.257 0.26 0.263 0.265 0.267 0.27 0.29 0.3 0.32 0.34 0.4 0.5 0.6 0.7 0.8 0.9];

parfor main_counter=1:500
    disp(num2str(main_counter))
    im_prefix = strcat('p', num2str(main_counter));
    
    testim_links = dir(strcat('data\database\direction_code\', im_prefix, '_*.bmp'));
    
    %read images to a structure
    dc_test = struct();
    canny_test = struct();
    im_len = length(testim_links);
    for idx = 1:im_len
        k = im_len - idx + 1;
        db_name = strcat('p', num2str(main_counter),'_', num2str(k), '.bmp');
        dc_test(k,1).im = read_image(strcat('data\database\direction_code\', db_name));
        canny_test(k,1).im = read_image(strcat('data\database\canny\', db_name));
    end
    
    %positive
    scores = report_score_pos_mex(dc_test, canny_test, im_len, 3);
    
    for sc=1:numel(scores)
        %score = floor(scores(sc)*10);
        score = scores(sc);
        idx_n1 = score <= error;
        idx_n2 = score > error;
        
        n1 = n1 + idx_n1;
        n2 = n2 + idx_n2;
    end
    
    total_pos = total_pos + numel(scores);
    
    %negative
    for t=(main_counter+1):500
       %load the two sets
       db_prefix = strcat('p', num2str(t));
       database = dir(strcat('data\database\direction_code\', db_prefix, '_*.bmp'));
       
       %read images to a structure
       dc_db = struct();
       canny_db = struct();
        db_len = length(database);
        for idx=1:db_len
            kdb = im_len - idx + 1;
            db_name = strcat('p', num2str(t),'_', num2str(kdb), '.bmp');
            dc_db(kdb,1).im = read_image(strcat('data\database\direction_code\', db_name));
            canny_db(kdb,1).im = read_image(strcat('data\database\canny\', db_name));
        end
       
       
       %get score
       scores = report_score_neg_mex(dc_test, dc_db, canny_test, canny_db, im_len, db_len, 3);
       for sc=1:numel(scores)
           score = scores(sc);
           idx_n3 = score <= error;
           idx_n4 = score > error;

           n3 = n3 + idx_n3;
           n4 = n4 + idx_n4;
       end
       
       total_neg = total_neg + numel(scores);
    end
end

%write result to file
output = [error; n1; n2; n3; n4];
fid = fopen('report_palmcode_without_al.txt', 'w');
fprintf(fid, '%s \n%9s %9s %9s %9s %9s\n', 'BLUE', 'THRESH', 'N1', 'N2', 'N3', 'N4');
fprintf(fid, '%9d %9d %9d %9d %9d\n', output);
fprintf(fid, '\n\n%10s %4d \n%10s %4d\n', 'Total_pos = ', total_pos, 'Total_neg = ', total_neg);
fclose(fid);

disp('nou fini')
winopen('report_palmcode_without_al.txt')
end


% function score = report_score_neg(dc_test, dc_db, canny_test, canny_db, im_len, db_len, bias)
%    %report the scores of two image structures (test and db)
%    score = [];
%    
%    for t=1:im_len
%        %score of the current image t on the database   
%        gloabl_min = [];
%        for tdb=1:db_len 
%            score_temp = palmcode_diff_weights_fused(dc_test(t).im, dc_db(tdb).im, canny_test(t).im, canny_db(tdb).im, bias);
% 
%            %global_min
%            gloabl_min = [gloabl_min, score_temp];
%        end
%        
%        %score
%        score = [score, gloabl_min];  
%    end
% end
% 
% function score = report_score_pos(dc_test, canny_test, im_len, bias)
%    %report the scores of two image structures (test and db)
%    score = [];
%    
%    for t=1:im_len-1
%        %score of the current image t on the database   
%        gloabl_min = [];
%        
%        for tdb=t+1:im_len
%            score_temp = palmcode_diff_weights_fused(dc_test(t).im, dc_test(tdb).im, canny_test(t).im, canny_test(tdb).im, bias);
% 
%            %global_min
%            gloabl_min = [gloabl_min, score_temp];
%        end
%        
%        %score
%        score = [score, gloabl_min];  
%    end
% end