% %% get the image
[path, name] = uigetfile('data\database\raw\*.bmp');
if ~name
    return
end
im1 = imread(fullfile(name, path));

%% process the image
if ndims(im1) == 3
    im1 = rgb2gray(im1);
end

imb = im2double(im1);

%%
%edge response
imfirstedge = edgeresponse(imb);
imsecondedge = edgeresponse(imcomplement(imfirstedge));
% imsecondedge = edgeresponse(imcomplement(imsecondedge), 'max');

%canny
%first edge response
% tlow = percentile(imfirstedge, 80);
% thigh = percentile(imfirstedge, 75);
len = size(imsecondedge, 1);
X = reshape(imsecondedge, 1, len*len);
threshold = prctile(X, [90, 60]);
thigh = threshold(1);
tlow = threshold(2);
[imfirstcanny, ~] = cannys(imfirstedge, tlow, thigh);

%second edge response
% tlow = percentile(imsecondedge, 95);
% thigh = percentile(imsecondedge, 35);
len = size(imsecondedge, 1);
X = reshape(imsecondedge, 1, len*len);
threshold = prctile(X, [90, 75]);
thigh = threshold(1);
tlow = threshold(2);
[imsecondcanny, template] = cannys(imsecondedge, 0.5, 0.8);

figure;
% set(gcf, 'PaperOrientation', 'portrait');
subplot(2, 3, 1), imshow(imb), title('original'); hold on;
subplot(2, 3, 2), imshow(imfirstedge), title('1st edge response');
subplot(2, 3, 3), imshow(imsecondedge), title('2ndedge response');
subplot(2, 3, 4), imshow(template), title('template');
subplot(2, 3, 5), imshow(imfirstcanny), title('1st e-resp canny');
subplot(2, 3, 6), imshow(imsecondcanny), title('2nd e-resp canny'); hold off;