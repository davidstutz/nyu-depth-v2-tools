function [] = collect_train_subsets()
% function [] = collect_train_subsets()
%
% Collects the train subsets given by list_train_subset.txt and
% list_train_subset_2.txt which both contain 100 images hand chosen such
% that multiple different scenes are represented in both subsets.
%
% David Stutz <david.stutz@rwth-aachen.de>

    load list_train_subset.txt

    baseDir = './NYUDepthV2/cropped-original/data';

    imageSubDir = sprintf('%s/images/train_subset', baseDir);
    if ~exist(imageSubDir)
        system(sprintf('mkdir %s', imageSubDir));
    end;

    depthSubDir = sprintf('%s/depth/train_subset', baseDir);
    if ~exist(depthSubDir)
        system(sprintf('mkdir %s', depthSubDir));
    end;
    
    groundTruthSubDir = sprintf('%s/groundTruth/train_subset', baseDir);
    if ~exist(groundTruthSubDir)
        system(sprintf('mkdir %s', groundTruthSubDir));
    end;
    
    for i = 1: size(list_train_subset, 1)
        system(sprintf('cp %s/images/train/%08d.jpg %s/images/train_subset/%08d.jpg', baseDir, list_train_subset(i), baseDir, list_train_subset(i)));
        system(sprintf('cp %s/groundTruth/train/%08d.mat %s/groundTruth/train_subset/%08d.mat', baseDir, list_train_subset(i), baseDir, list_train_subset(i)));
		system(sprintf('cp %s/depth/train/%08d.png %s/depth/train_subset/%08d.png', baseDir, list_train_subset(i), baseDir, list_train_subset(i)));
    end;

end

