function [] = process_data_to(dir)
%process_data_to(dir) will process the labeled data and save the results to directory dir.

load nyu_depth_v2_labeled.mat instances
N = size(instances,3);
fprintf('Reading instances ...\n');
for n = 1:N
    imwrite(instances(:,:,n),[dir '/instances/instance' num2str(n) '.png']);%uint8
end
clear instances

load nyu_depth_v2_labeled.mat labels
fprintf('Reading labels ...\n');
for n = 1:N
    imwrite(labels(:,:,n),[dir '/labels/label' num2str(n) '.png']);%uint16
end
clear labels

load nyu_depth_v2_labeled.mat names
file_names = fopen([dir '/names.txt'],'wt');
fprintf('Reading names ...\n');
for c = 1:size(names)
    fprintf(file_names,'%s\n', names{c});%char
end
fclose(file_names);
clear names

load nyu_depth_v2_labeled.mat scenes
file_scenes = fopen([dir '/scenes.txt'],'wt');
fprintf('Reading scenes ...\n');
for c = 1:size(scenes)
    fprintf(file_scenes,'%s\n', scenes{c});%char
end
fclose(file_scenes);
clear scenes

fprintf('Done.\n');

end