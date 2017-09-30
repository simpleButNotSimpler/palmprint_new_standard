function report_palmcode_verif_dp()

n1 = zeros(1, 23);
n2 = n1;
n3 = n1;
n4 = n1;
total_pos = 0;
total_neg = 0;

error = [0 0.05 0.1 0.15 0.2 0.25 0.255 0.257 0.26 0.263 0.265 0.267 0.27 0.29 0.3 0.32 0.34 0.4 0.5 0.6 0.7 0.8 0.9];

for main_counter=1:500
    disp(num2str(main_counter))
    im_prefix = strcat('p', num2str(main_counter));
    
    testim = dir(strcat('data\database\direction_code\', im_prefix, '_*.bmp'));
    
    %positive
    scores = report_score(testim, testim, 1);
    
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
       
       %get score
       scores = report_score(testim, database, 0);
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


function score = report_score(testimage, database, same)
   %length of the database
   im_len = length(testimage);
   score = [];
   
   for t=1:im_len
       %update database
       if same
           database(1) = [];
       end
       
       gloabl_min = build_alignment_one(testimage(t).name, database)
       
       %score
       score = [score, gloabl_min];  
   end
end

function gloabl_min = build_alignment_one(test_im_name, database)
db_len = length(database);
gloabl_min = [];

dc_test_im = read_image(fullfile('data\database\direction_code', test_im_name));
canny_test_im = read_image(fullfile('data\database\canny', test_im_name));
if isempty(find(dc_test_im, 1))
   return
end

for counter=1:db_len
    % get the image image for one person
    dc_db_im = read_image(fullfile(database(counter).folder, database(counter).name));
    canny_db_im = read_image(fullfile('data\database\canny', database(counter).name));
    
    if isempty(find(dc_db_im, 1))
        continue
    end
    
    score = palmcode_diff_weights_fused(dc_test_im, dc_db_im, canny_test_im, canny_db_im, 3);
    
    %global_min
    gloabl_min = [gloabl_min, score];
end

end