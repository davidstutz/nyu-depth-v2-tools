function [] = crop_dataset()
% function [] = crop_dataset()
%
% Due to the Kinect, there is a small border around the image which is
% white and not important for the labelling. For using superpixel
% algorithms, this area should be removed.
%
% This function removes this border for all images of the dataset which has
% been converted using convert_dataset.m.
%
% Therefore it first determines the maximum white region at each border and
% prints them (maxLeft, maxRight, maxTop, maxBottom). The maximum of these
% values is the number of pixels to be cut off at each border.
%
% Currently the number of pixels cropped at each border is 16px! See below
% to change this!
%
% Note that in the adapted version of convert_dataset.m the background
% label is one.
%
% David Stutz <david.stutz@rwth-aachen.de>

    directories = {'train'; 'test'};
    
    % The directories to use for cropping the dataset.
    % Remember to relabel the ground truth segmentations first if semantic
    % segmentation is not needed.
    imgBaseDir = './NYUDepthV2/original/data/images/';
    depthBaseDir = './NYUDepthV2/original/data/depth/';
    gtBaseDir = './NYUDepthV2/original/data/groundTruth/';
    
    % The output directories, use different directories to not overwrite
    % the original dataset.
    imgOutBaseDir = './NYUDepthV2/cropped-original/data/images/';
    depthOutBaseDir = './NYUDepthV2/cropped-original/data/depth/';
    gtOutBaseDir = './NYUDepthV2/cropped-original/data/groundTruth/';
    
    maxLeft = 0;
    maxRight = 0;
    maxTop = 0;
    maxBottom = 0;

    for d = 1: size(directories, 1)
        inDir = [imgBaseDir directories{d}];
        segDir = [gtBaseDir directories{d}];

        images = dir(sprintf('%s/*.jpg', inDir));
        for i = 1: numel(images)

            image = imread(sprintf('%s/%s', inDir, images(i).name));
            groundTruth = load(sprintf('%s/%s.mat', segDir, images(i).name(1:end - 4)));
            seg = groundTruth.groundTruth{1,1}.Segmentation;

            % determine the number of white pixels at the left and right border
            for k = 10: size(image, 1) - 10

                % left border
                l = 1;
                count = 0;
                while l <= size(image, 2) && image(k, l, 1) == 255 && image(k, l, 2) == 255 && image(k, l, 3) == 255 && seg(k, l) == 1
                    l = l + 1;
                    count = count + 1;
                end;

                if count > maxLeft
                    maxLeft = count;
                end;

                % right border
                l = size(image, 2);
                count = 0;
                while l > 0 && image(k, l, 1) == 255 && image(k, l, 2) == 255 && image(k, l, 3) == 255 && seg(k, l) == 1
                    l = l - 1;
                    count = count + 1;
                end;

                if count > maxRight
                    maxRight = count;
                end;
            end;

            % determine the number of white pixels at top and bottom border
            for l = 10: size(image, 2) - 10
                k = 1;
                count = 0;
                while k <= size(image, 1) && image(k, l, 1) == 255 && image(k, l, 2) == 255 && image(k, l, 3) == 255 && seg(k, l) == 1
                    k = k + 1;
                    count = count + 1;
                end;

                if count > maxTop
                    maxTop = count;
                end;

                % right border
                k = size(image, 1);
                count = 0;
                while k > 0 && image(k, l, 1) == 255 && image(k, l, 2) == 255 && image(k, l, 3) == 255 && seg(k, l) == 1
                    k = k - 1;
                    count = count + 1;
                end;

                if count > maxBottom
                    maxBottom = count;
                end;
            end;
        end;
    end;
    
    cutOff = maxTop;
    if maxBottom > cutOff
        cutOff = maxBottom;
    end;
    if maxLeft > cutOff
        cutOff = maxLeft;
    end;
    if maxRight > cutOff
        cutOff = maxRight;
    end;
    
    cutOff = 16;
    
    fprintf('%d pixels will be cut off at each border!\n', cutOff);
    
    for d = 1: size(directories, 1)
        inDir = [imgBaseDir directories{d}];
        depthDir = [depthBaseDir directories{d}];
        segDir = [gtBaseDir directories{d}];
        
        outDir = [imgOutBaseDir directories{d}];
        outDepthDir = [depthOutBaseDir directories{d}];
        outSegDir = [gtOutBaseDir directories{d}];
        
        if ~exist(outDir) 
            system(['mkdir -p ' outDir]);
        end;
        
        if ~exist(outDepthDir) 
            system(['mkdir -p ' outDepthDir]);
        end;
        
        if ~exist(outSegDir)
            system(['mkdir -p ' outSegDir]);
        end;
        
        images = dir(sprintf('%s/*.jpg', inDir));
        for i = 1: numel(images)

            % crop image
            imagePath = sprintf('%s/%s', inDir, images(i).name);
            image = imread(imagePath);
            
            height = size(image, 1);
            width = size(image, 2);
            
            newImage = image(cutOff + 1:height - cutOff, cutOff + 1:width - cutOff, :);
            imwrite(newImage, sprintf('%s/%s.jpg', outDir, images(i).name(1:end - 4)));
            
            % crop depth image
            depthPath = sprintf('%s/%s.png', depthDir, images(i).name(1:end - 4));
            depthImage = imread(depthPath);
            newDepthImage = depthImage(cutOff + 1:height - cutOff, cutOff + 1:width - cutOff, :);
            imwrite(newDepthImage, sprintf('%s/%s.png', outDepthDir, images(i).name(1:end - 4)));
            
            % crop ground truth segmentation
            gtPath = sprintf('%s/%s.mat', segDir, images(i).name(1:end - 4));
            oldGroundTruth = load(gtPath);
            seg = oldGroundTruth.groundTruth{1,1}.Segmentation;
            bdry = oldGroundTruth.groundTruth{1,1}.Boundaries;
            
            newSeg = seg(cutOff + 1:height - cutOff, cutOff + 1:width - cutOff);
            newBdry = bdry(cutOff + 1:height - cutOff, cutOff + 1:width - cutOff);
            
            groundTruth = cell(1);
            groundTruth{1}.Segmentation = newSeg;
            groundTruth{1}.Boundaries = newBdry;
             
            save(sprintf('%s/%s.mat', outSegDir, images(i).name(1:end - 4)), 'groundTruth');
            
            csvwrite(sprintf('%s/%s.csv', outStructureGTDir, images(i).name(1:end - 4)), newLabels);
        end;
    end;
end