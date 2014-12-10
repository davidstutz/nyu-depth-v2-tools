function [] = relabel_dataset()
% function [] = relabel_dataset()
%
% Used to relabel the labels given by the NYU dataset. For evaluation, the
% semantic segmentation is irrelevant, but to speed up evaluation it is
% beneficial that the labels are bounded to the smallest possible range.
%
% David Stutz <david.stutz@rwth-aachen.de>

    load list_train.txt
    load list_test.txt
    
    % Will take ground truth from inputBaseDir, relabel them and save them
    % to outputBaseDir.
    inputBaseDir = './NYUDepthV2/original/data/groundTruth';
    outputBaseDir = './NYUDepthV2/relabeled/data/groundTruth';
    
    types = {'train'; 'test'};
    
    for t = 1: size(types, 1)
        if strcmp(types{t}, 'train')
            list = list_train;
        else
            list = list_test;
        end;
        
        inputDir = sprintf('%s/%s', inputBaseDir, types{t});
        outputDir = sprintf('%s/%s', outputBaseDir, types{t});

        if ~exist(outputDir)
            system(sprintf('mkdir -p %s', outputDir));
        end;

        for l = 1: size(list)
            groundTruthFile = sprintf('%s/%08d.mat', inputDir, list(l));

            load(groundTruthFile);

            groundTruth{1}.Segmentation = groundTruth{1}.Segmentation + 1;

            label = 2;
            labels = ones(max(max(groundTruth{1}.Segmentation)), 1)*(-1);
            labels(1) = 1;

            for i = 1: size(groundTruth{1}.Segmentation, 1)
                for j = 1: size(groundTruth{1}.Segmentation, 2)
                    % check whether this is a new label
                    if labels(groundTruth{1}.Segmentation(i, j)) == -1
                        labels(groundTruth{1}.Segmentation(i, j)) = label;
                        label = label + 1;
                    end;

                    % set new label
                    groundTruth{1}.Segmentation(i, j) = labels(groundTruth{1}.Segmentation(i, j));
                end;
            end;
            
            save(sprintf('%s/%08d.mat', outputDir, list(l)), 'groundTruth');
        end;
    end;

end

