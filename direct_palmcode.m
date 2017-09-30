function score = direct_palmcode(dc_test_im, canny_test_im, database_dc, database_canny, db_len, bias)
%%take one test image name and one direction_code database as input, it outputs the minimum palmcode
%difference between the im and the images in the database without using alignement

score = inf;

for k=1:db_len    
    score_dc_orig = palmcode_diff_weights_fused(dc_test_im, database_dc(k).im, canny_test_im, database_canny(k).im, bias);
        
    %update global minimum
    if (score_dc_orig < score) && (score_dc_orig ~= 0) 
        score = score_dc_orig;
    end
end
end