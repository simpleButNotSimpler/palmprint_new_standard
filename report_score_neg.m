function score = report_score_neg(dc_test, dc_db, canny_test, canny_db, im_len, db_len, bias)
   %report the scores of two image structures (test and db)
   score = [];
   
   for t=1:im_len
       %score of the current image t on the database   
       gloabl_min = [];
       for tdb=1:db_len 
           score_temp = palmcode_diff_weights_fused(dc_test(t).im, dc_db(tdb).im, canny_test(t).im, canny_db(tdb).im, bias);

           %global_min
           gloabl_min = [gloabl_min, score_temp];
       end
       
       %score
       score = [score, gloabl_min];  
   end
end
