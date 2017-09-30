im_prefix = strcat('p', num2str(1));
    
testim_links = dir(strcat('data\database\direction_code\', im_prefix, '_*.bmp'));

%read images to a structure
dc_test = struct();
canny_test = struct();
im_len = length(testim_links);
for idx = 1:im_len
    k = im_len - idx + 1;
    db_name = strcat('p', num2str(2),'_', num2str(k), '.bmp');
    dc_test(k,1).im = read_image(strcat('data\database\direction_code\', db_name));
    canny_test(k,1).im = read_image(strcat('data\database\canny\', db_name));
end

% score = report_score_pos(dc_test, canny_test, im_len, 3)

%neg
db_prefix = strcat('p', num2str(2));
database = dir(strcat('data\database\direction_code\', db_prefix, '_*.bmp'));

%read images to a structure
dc_db = struct();
canny_db = struct();
db_len = length(database);
for idx=1:db_len
    kdb = im_len - idx + 1;
    db_name = strcat('p', num2str(1),'_', num2str(kdb), '.bmp');
    dc_db(kdb,1).im = read_image(strcat('data\database\direction_code\', db_name));
    canny_db(kdb,1).im = read_image(strcat('data\database\canny\', db_name));
end

scores = report_score_neg(dc_test, dc_db, canny_test, canny_db, im_len, db_len, 3)
scores = report_score_neg_mex(dc_test, dc_db, canny_test, canny_db, im_len, db_len, 3)