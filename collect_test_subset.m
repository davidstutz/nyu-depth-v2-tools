function [] = collect_test_subsets()
% function [] = collect_test_subsets()
%
% Collects the test subset given by list_test_subset.txt.
%
% David Stutz <david.stutz@rwth-aachen.de>

    load './nyu_tools/list_test_subset.txt' list_test_subset
    
    baseDir = './NYUDepthV2/cropped-original/data';

    depthSubDir = sprintf('%s/depth/test_subset', baseDir);
    if ~exist(depthSubDir)
        system(sprintf('mkdir %s', depthSubDir));
    end;
    
    rawDepthSubDir = sprintf('%s/rawDepth/test_subset', baseDir);
    if ~exist(rawDepthSubDir)
        system(sprintf('mkdir %s', rawDepthSubDir));
    end;
    
    groundTruthSubDir = sprintf('%s/groundTruth/test_subset', baseDir);
    if ~exist(groundTruthSubDir)
        system(sprintf('mkdir %s', groundTruthSubDir));
    end;
    
    for i = 1: size(list_test_subset, 1)
		system(sprintf('cp %s/images/test/%08d.jpg %s/images/test_subset/%08d.jpg', baseDir, list_test_subset(i), baseDir, list_test_subset(i)));
        system(sprintf('cp %s/groundTruth/test/%08d.mat %s/groundTruth/test_subset/%08d.mat', baseDir, list_test_subset(i), baseDir, list_test_subset(i)));
        system(sprintf('cp %s/depth/test/%08d.png %s/depth/test_subset/%08d.png', baseDir, list_test_subset(i), baseDir, list_test_subset(i)));
    end;

end

