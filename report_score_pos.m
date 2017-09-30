function score = report_score_pos(dc_test, canny_test, im_len, bias)
   %report the scores of two image structures (test and db)
   score = [];
   
   for t=1:im_len-1
       %score of the current image t on the database   
       gloabl_min = [];
       
       for tdb=t+1:im_len
           score_temp = palmcode_diff_weights_fused(dc_test(t).im, dc_test(tdb).im, canny_test(t).im, canny_test(tdb).im, bias);

           %global_min
           gloabl_min = [gloabl_min, score_temp];
       end
       
       %score
       score = [score, gloabl_min];  
   end
end