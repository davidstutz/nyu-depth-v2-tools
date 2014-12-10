function [] = convert_dataset(dir, factor)
% function [] = convert_dataset()
%
% Converts the NYU Depth V2 dataset to be BSDS500 conform. Therefore, the
% images are halfed in size and split into a training and test set
% according to list_train.txt and list_test.txt.
%
% The output directory can be adjusted by having a look at the functions
% generate_half, generate_depth and
% generate_groundtruth_medfilt.
% 
% Original README.txt by Liefeng Bo:
% Run the script convert_dataset.m to download the dataset, reduce the resolution
% to half (320x240), clean up some "double contours" in the groundtruth, and save
% them in the Berkeley Segmentation Benchmark (BSDS) format. Once in BSDS format,
% it is easy to modify the Berkeley gPb benchmarking code to point to the new
% dataset locations. The data is split into 60% training and 40% test, randomly.
% 
% "Double contours" refer to minor artifacts in the NYU groundtruth where the
% labels are given as semantic regions, not scene segmentations. Thus
% occassionally a thin strip of unlabeled pixels exist between two regions that
% should be adjacent, and it is a problem for a boundary/segmentation evaluation.
% We have a simple median filtering step to remedy the issue.
%
% seg2bdry.m is from the Berkeley gPb software.
% mediannan_int.m is modified from the code shown at http://www.mathworks.com/matlabcentral/newsreader/view_thread/251787.
% 
% INPUT:
%   dir: 	output directory
%
%   factor: factor for resampling (for example 0.5 for half the
% 			image size)
%
% Original by Liefeng Bo <lifengb@gmail.com>
% Adapted by David Stutz <david.stutz@rwth-aachen.de>

    if nargin < 1
        dir ='./NYUDepthV2/data'
    end;

    % Defines the factor of which the width and height of the image is
    % reduced.
    if nargin < 2
        factor = 1.;
    end;
    
    generateImages = 1;
	generateDepth = 1;
	generateGroundTruth = 1;
    
    load list_train.txt
    load list_test.txt

    if generateImages
        load ./NYUDepthV2/nyu_depth_v2_labeled.mat images
        fprintf('Generating color images ...\n');
        generate_images(images, list_train, [dir '/images/train'], factor);
        generate_images(images, list_test, [dir '/images/test'], factor);
        clear images
    end;
    
    if generateDepth
        load ./NYUDepthV2/nyu_depth_v2_labeled.mat depths
        fprintf('Generating depth images ...\n');
        generate_depth(depths, list_train, [dir '/depth/train'], factor);
        generate_depth(depths, list_test, [dir '/depth/test'], factor);
        clear depths
    end;
    
    if generateGroundTruth
        % generate cleaned-up groundtruth in BSDS format
        fprintf('Generating ground truth ...\n');
        load ./NYUDepthV2/nyu_depth_v2_labeled.mat images labels instances
        mask_border = find_border_region(images);
        generate_groundtruth_medfilt(labels, instances, mask_border, list_train, [dir '/groundTruth/train'], factor);
        generate_groundtruth_medfilt(labels, instances, mask_border, list_test, [dir '/groundTruth/test'], factor);
        clear labels
        clear instances
    end;
    
    fprintf('Done.\n');
end

function mask_border = find_border_region(images)

    [im_h, im_w, ~, nframe] = size(images);

    mask_border = ones(im_h,im_w);
    for ii = 1: nframe
      im = rgb2gray(images(:,:,:,ii));
      mask_border = (mask_border & (im >= 253));
    end;
end

function generate_images(images, list, outdir, factor)
% function generate_half(images, list, outdir, factor)
%
% This function is used to resize the images of NYU. The factor defines the
% resizing factor.

    if ~exist(outdir)
        system(['mkdir -p ' outdir]);
    end;

    for ii = list',
      id = num2str(ii, '%08d');
      img = images(:, :, :, ii);
      
      img = imresize(img, factor);
      imwrite(img, [outdir '/' id '.jpg'], 'Quality', 98);
    end;
end

function generate_raw_depth(rawDepths, list, outdir, factor)
% function generate_raw_depth(rawDepths, list, outdir, factor)
%
% Similar to generate_depth(depths, list, outdir, factor), this function
% generates the raw depth images in the given list and directory.
% The images are resampled using the given factor and every pixel where
% no depth information is given is indicated by a zero.
%
% David Stutz <david.stutz@rwth-aachen.de>

    step = 1./factor;

    if ~exist(outdir)
        system(['mkdir -p ' outdir]);
    end;

    if step > 1
        fprintf('Filling holes after subsampling the image with step %d ...\n', step);
    end;
    
    for ii = list',
      id = num2str(ii, '%08d');
      rawDepth = rawDepths(:, :, ii);
      depth = rawDepth(step:step:end, step:step:end);
      
      % fill small holes in depth after subsampling.
      if step > 1
          for i = 1: step: size(depth, 1)
              for j = 1: step: size(depth, 2)
                  if depth(i, j) == 0
                    if i > 1 && depth(i - 1, j) ~= 0
                        depth(i, j) = depth(i - 1, j);
                    end;
                    if j > 1 && depth(i, j - 1) ~= 0
                        depth(i, j) = depth(i, j - 1);
                    end;
                    if i < size(depth, 1) && depth(i + 1, j) ~= 0
                        depth(i, j) = depth(i + 1, j);
                    end;
                    if j < size(depth, 2) && depth(i, j + 1) ~= 0
                        depth(i, j) = depth(i, j + 1);
                    end;
                  end;
              end;
          end;
      end;
      
      imwrite(uint16(depth*1000), [outdir '/' id '.png']);
    end;

end

function generate_depth(depths, list, outdir, factor)
% function generate_depth(depths, list, outdir, factor)
%
% Subsamples the depth images by the defined step size.

    step = 1./factor;

    if ~exist(outdir)
        system(['mkdir -p ' outdir]);
    end;

    for ii = list',
      id = num2str(ii, '%08d');
      depth = depths(:, :, ii);
      depth = depth(step:step:end, step:step:end);
      imwrite(uint16(depth*1000), [outdir '/' id '.png']);
    end;
end

function generate_groundtruth_medfilt(labels, instances, mask_border, list, outdir, factor)
% function generate_groundtruth_medfilt(labels, instances, mask_border, list, outdir, factor)
%
% This function is used to find and fill regions of the depth images that
% require filling.
%
% The factor defines the resizing factor for the images.

    if ~exist(outdir)
        system(['mkdir -p ' outdir]);
    end;

    maxlabel = 1000;
    assert(max(labels(:)) <= maxlabel);
    
    for ii=list'
      id = num2str(ii, '%08d');
      
      % find out the region that needs to be filled, use dilate/erode
      margin = 5;
      foreground = (labels(:, :, ii) > 0);
      foreground = imerode(imdilate(foreground, strel('disk', margin)), strel('disk', margin));
      cc = bwconncomp(~foreground);
      A = regionprops(cc, 'Area');
      min_background_area = 500;
      indA = find([A.Area] < min_background_area);
      
      for k = indA
          foreground(cc.PixelIdxList{k}) = 1;
      end;
      
      % now do repeated median filter to fill in foreground
      seg = double(instances(:, :, ii))*maxlabel + double(labels(:, :, ii));
      seg0 = seg;
      seg(seg == 0) = nan;
      
      for iter = 1: 100
        seg2 = mediannan_int(seg, 5);
        ind = find(isnan(seg) & ~isnan(seg2) & foreground);
        
        if isempty(ind)
            break;
        end;
        
        seg(ind) = seg2(ind);
      end;
      seg(isnan(seg)) = 0;

      % groundTruth{1}.Segmentation=uint16(seg .* (1-mask_border));    % objects start with 1; 0 is background
      % groundTruth{1}.Boundaries=logical(seg2bdry(seg,'imageSize')) & ~imdilate(mask_border,strel('disk',5));
      % save([outdir '/' id '.mat'],'groundTruth');

      step = 1./factor;
      
      groundTruth{1}.Segmentation = uint16(seg(step:step:end, step:step:end).*(1 - mask_border(step:step:end, step:step:end)));
      groundTruth{1}.Boundaries = logical(seg2bdry(seg(step:step:end, step:step:end), 'imageSize')) & ~imdilate(mask_border(step:step:end, step:step:end), strel('disk', 2));
      
      save([outdir '/' id '.mat'], 'groundTruth');
    end;
end
