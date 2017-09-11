function score = aligned_palmcode(im_test_name, database)
%take one cleaned image and one cleaned database as input, it outputs the minimum palmcode
%difference between the im and the images in the database using alignement
%and the minimum difference of their palmlines
    
%get the best match for im_test in the database
folder = database(1).folder;
im_test = read_image(fullfile('data\testimages\cleaned', im_test_name));
score = inf;

for counter=1:numel(database)
    im_db = read_image(fullfile(folder, database(counter).name));
    
    %align the two current images
    try
        [angle, trans, cf, direction, ~] = test_alignment_one(im_test, im_db);
    catch
        cf = 0;
    end
    
    %get the best results
    if cf == 0
       continue
    end
    
    %compute palmcode
    db_im_name = database(counter).name;
    min_err = rotated_im_scores(im_test_name, db_im_name, angle, trans, cf, direction);
    
    if min_err < score
        score = min_err;
    end
end
end

%return the alignement transformation and he direction between two images
function [angle, trans, cf, direction, err] = test_alignment_one(moving_im, fixed_im)
cf = 0;
direction = 0;
   

if isempty(find(fixed_im, 1))
    return
end

% datasets
[y, x] = find(fixed_im);
M = [x, y];

[y, x] = find(moving_im);
D = [x, y];

%first way
[~, T1, ~, angle1, er1, cf1] = icp(D, M, 50, 0.0001, 0);

%second way
[~, T2, ~, angle2, er2,  cf2] = icp(M, D, 50, 0.0001, 0);

%toc   
% statistics
 er1_1 = er1(end);
 er2_1 = er2(end);

 if er1_1 < er2_1
     direction = 0;
     cf = cf1;
     angle = angle1;
     trans = T1;
     err = er1_1;
 else
     direction = 1;
     cf = cf2;
     angle = angle2;
     trans = T2;
     err = er2_1;
 end
end

%scores of the rotated palmcodes
function score = rotated_im_scores(test_im_name, db_im_name, angle, trans, cf, direction)

%actual code
dc_test_name = fullfile('data\testimages\direction_code', test_im_name);
dc_db_name = fullfile('data\database\direction_code', db_im_name);
raw_test_name = fullfile('data\testimages\raw', test_im_name);
raw_db_name = fullfile('data\database\raw', db_im_name);

if direction
   dc_db_name = dc_test_name;
   
   temp = raw_test_name;
   raw_test_name = raw_db_name;
   raw_db_name = temp;
end


raw_test_im = im2double(read_image(raw_test_name));
raw_db_im = im2double(read_image(raw_db_name));
dc_db_im = read_image(dc_db_name);

% transform the original image
RA = imref2d(size(raw_test_im));
dc_imt = imtranslate(raw_test_im, RA, trans');
raw_rotated_im = rotateAround(dc_imt, cf(2), cf(1), angle);

[restored_raw_im, non_palm_region] = restore_im(raw_rotated_im, raw_db_im);

[temp, ~] = edgeresponse(restored_raw_im);
[~, dc_output_im] = edgeresponse(imcomplement(temp));

%crop the direction-code image
% [row, col, dc_cropped_output_im] = crop_rotation(dc_output_im);
% dc_cropped_db_im = dc_db_im(row(1):row(2), col(1):col(2));

% score = palmcode_diff(dc_cropped_output_im, dc_cropped_db_im);
dc_output_im(non_palm_region) = 180;
% dc_db_im(non_palm_region) = 180;

score = palmcode_diff(dc_output_im, dc_db_im);
end