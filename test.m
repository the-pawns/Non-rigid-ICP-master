% Add path
addpath(genpath('../toolbox_graph/toolbox_graph/'));
addpath(genpath('../icp/'));
addpath(genpath(''));

% Load data
base_path = 'G:\2020\Last_half\otherwork\Non-rigid-ICP-master\data\';
scan_path = 'G:\2020\Last_half\otherwork\Non-rigid-ICP-master\data\';

base_name = 'faceSource.mat';     
scan_name = 'faceTarget.mat';
%加入3D牙齿匹配
 [test1_vertices, test1_faces, test1_normals, test1] = stlread('G:\2020\Last_half\otherwork\Non-rigid-ICP-master\test1.stl');
 [target1_vertices, target1_faces, target1_normals, target1] = stlread('G:\2020\Last_half\otherwork\Non-rigid-ICP-master\target1.stl');
 target2_faces=target1_faces';
 target2_vertices=target1_vertices';        %转置一下
% target2_normals=target1_normals';
 test2_faces=test1_faces';
 test2_vertices=test1_vertices';
% test2_normals=test1_normals';
% patch(test1_vertices, test1_faces, test1_normals, test1)
 %加入完成
load([base_path base_name]);
base_ver = Source.vertices';
base_tri = Source.faces';          %  改名称

load([scan_path scan_name]);
scan_ver = Target.vertices';
scan_tri = Target.faces';

% Select face parts of scan 
% base_min = min(base_ver(3, :))-0.015;
% [index, value] = find(scan_ver(3, :)>=base_min*10);
% scan_ver = scan_ver(:, value);
% test_tri = [];
% for i = 1:length(scan_tri)
% 	[judge, ind] = ismember(scan_tri(:, i), value);
% 	if judge(1) && judge(2) && judge(3) == 1
% 		test_tri = [test_tri, ind];
%     end
% end
% scan_tri = test_tri;
% a = scan_ver';
% c = double(scan_tri');
% b = base_ver';
% d = double(base_tri');
% save('output/select_part/points/scan_ver.txt', 'a', '-ascii');
% save('output/select_part/points/scan_tri.txt', 'c', '-ascii');
% save('output/select_part/points/base_ver.txt', 'b', '-ascii');
% save('output/select_part/points/base_tri.txt', 'd', '-ascii');

% Calculation normal
% base_norm = NormDirection(base_ver, base_tri);
% scan_norm = NormDirection(scan_ver, scan_tri);

% Save mesh struct  #构造网格结构
field1 = 'faces'; field2 = 'vertices'; field3 = 'normals';
base_s = struct(field1, base_tri', field2, base_ver', field3, Source.normals');
scan_s = struct(field1, scan_tri', field2, scan_ver', field3, Target.normals');

%constract 类似结构
test1_s = struct(field1, test2_faces', field2, test2_vertices', field3, test1_normals');
target1_s = struct(field1, target2_faces', field2, target2_vertices', field3, target1_normals');

% Specify that surface normals are available and can be used.
Options.useNormals = 1;

% Specify that the source deformations should be plotted.
Options.plot = 1;

% Specify that the landmarks term are available and can be used.
Options.landmarks = 0;

% Selected landmarks
ls_source = [];
ls_target = [];

% x = base_ver(1, :); y = base_ver(2, :); z = base_ver(3, :);
% X = scan_ver(1, :); Y = scan_ver(2, :); Z = scan_ver(3, :);
% figure;hold on;
% scatter3(x(:), y(:), z(:) ,'b.');
% scatter3(x(ls_source), y(ls_source), z(ls_source) ,'r*');
% scatter3(X(:), Y(:), Z(:) ,'y.');
% scatter3(X(ls_target), Y(ls_target), Z(ls_target) ,'ro');

% Perform non-rigid ICP
% [pointsTransformed, X] = nricp_landmarks(test1_s, target1_s, Options, ls_source, ls_target);   % 改appel  这应该是一个匹配函数
 [pointsTransformed, X] = nricp_landmarks(base_s, scan_s, Options, ls_source, ls_target);   % 改appel  这应该是一个匹配函数
% faces = double(base_s.faces);
% save('output/point_cloud/vertices.txt', 'pointsTransformed', '-ascii');
% save('output/point_cloud/faces.txt', 'faces', '-ascii');



