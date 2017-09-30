function score = palmcode_diff_weights_fused(im1, im2, palm_im1, palm_im2, bias)
%take two palmcode and two cannys as input and output the difference of their histogram
    
    siz1 = size(im1);
    bsize = floor(siz1(1)/7);
    blocks = 1:bsize:siz1(1)+1;
    blocks(end) = siz1(1)+1;
    
    %fuse the palm images
    palm_im1(palm_im2 > 0) = 255;
    
    weights = ones(siz1);
    weights(palm_im1 > 0) = bias;
    score = histo_diff(im1, im2, weights, blocks);
end

function score = histo_diff(im1, im2, weights, range)
   len = numel(range) - 1;
   score = 0;
   
   for m=1:len
       for n=1:len
          block1 = im1(range(m):range(m+1)-1, range(n):range(n+1)-1);
          block2 = im2(range(m):range(m+1)-1, range(n):range(n+1)-1);
          block_weights = weights(range(m):range(m+1)-1, range(n):range(n+1)-1);
          
         [histo_vector, counter] = code_block_histo(block1, block2, block_weights);
          
          score = score + sum(abs(histo_vector)) / counter;
       end       
   end
   
   score = score / (len*len);
end

function [hv1, counter] = code_block_histo(im1, im2, block_weights)
   hv1 = zeros(1, 9);
   [row, col] = size(block_weights);
   counter = 0;
   
   for t=1:row
       for k=1:col
           idx1 = (im1(t,k)/20) + 1;
           idx2 = (im2(t,k)/20) + 1;
           
           inc = block_weights(t,k);
           
           hv1(idx1) =  hv1(idx1) + inc;
           hv1(idx2) =  hv1(idx2) - inc;
           counter = counter + inc;
       end
   end
end