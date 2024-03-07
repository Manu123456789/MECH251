# MECH251
Finite Element Analysis
clc; clear all; close all;
% Uncomment function def line 159 to run

filenames = {'sphere.obj', 'shuttle.obj', 'ellipsoid.obj', 'cessna.obj'};

for f = 1:length(filenames)

filename = filenames{f};

[node_num, face_num, normal_num, order_max] = obj_size(filename);
[node_xyz, face_order, face_node, normal_vector, vertex_normal] = obj_read( ...
    filename, node_num, face_num, normal_num, order_max);

figure;
obj_display(filename);

% triangulation
c=0;
for i=1:face_num
    for j=1:face_order(i)-2
        c=c+1;
        new_face_node(:,c) = face_node([1 j+1 j+2],i);
    end
end

[row,new_face_num] = size(new_face_node);

% find the centroid of the object

centroid = calculate_centroid(node_xyz);
fprintf('Centroid: (%f, %f, %f)\n', centroid(1), centroid(2), centroid(3));

% move the center of the coordinate system to the centroid

translated_node_xyz = translate_to_centroid(centroid, node_xyz);

% scale the object (Normalize)

normalized_vertices = normalize_object(translated_node_xyz);

% rotation to align with principal axes

aligned_node_xyz = align_with_principal_axes(translated_node_xyz);

% Credits: ROBERT OSADA, THOMAS FUNKHOUSER, BERNARD CHAZELLE, and DAVID
% DOBKIN, "Shape Distributions", ACM Transactions on Graphics, Vol. 21, No. 4, October
% 2002, Pages 807–832

% generate uniformly sampled points on the surface of the object

Sampled_points = sample_surface(normalized_vertices, new_face_node, 1024^2);

% Plot the mesh
figure;
trisurf(new_face_node', normalized_vertices(1,:), normalized_vertices(2,:), normalized_vertices(3,:), ...
    'FaceColor', 'cyan', 'FaceAlpha', 0.8);
hold on;

% Plot the sampled points
plot3(Sampled_points(:,1), Sampled_points(:,2), Sampled_points(:,3), ...
    'r.', 'MarkerSize', 10); % Red dots for sampled points

% Enhance the plot
axis equal; % Equal scaling for x, y, z axes
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Sampled Points on OBJ Mesh');
hold off;

% A3 shape function, 

A3_distribution_plot(Sampled_points);

% Credits: ROBERT OSADA, THOMAS FUNKHOUSER, BERNARD CHAZELLE, and DAVID
% DOBKIN, "Shape Distributions", ACM Transactions on Graphics, Vol. 21, No. 4, October
% 2002, Pages 807–832

% D2 shape function

D2_distribution_plot(Sampled_points);

% Credits: ROBERT OSADA, THOMAS FUNKHOUSER, BERNARD CHAZELLE, and DAVID
% DOBKIN, "Shape Distributions", ACM Transactions on Graphics, Vol. 21, No. 4, October
% 2002, Pages 807–832

% D1 shape function

% shell model with 60 shells

% % Distances from each point to the centroid
% distances = sqrt(sum((Sampled_points - centroid).^2, 2));
% 
% % Number of shells
% numShells = 60;
% 
% % Range for the shells
% maxDistance = max(distances);
% minDistance = min(distances);
% shellEdges = linspace(minDistance, maxDistance, numShells + 1);
% 
% % Count points in each shell
% [counts, edges] = histcounts(distances, shellEdges);
% 
% % Histogram
% figure;
% bar(edges(1:end-1), counts, 'histc');
% xlabel('Distance from Centroid');
% ylabel('Count');
% title('Shape Histogram with 60 Shells');
% axis tight;
% set(gca, 'XTick', linspace(minDistance, maxDistance, numShells/10));
% grid on;

% Number of bins
B = 60; % Number of bins for the histogram

% Distances from each point to the center of mass
distances = sqrt(sum((Sampled_points - centroid).^2, 2));

% Determine the range for the histogram bins
maxDistance = max(distances);
minDistance = min(distances); 
binEdges = linspace(minDistance, maxDistance, B + 1);

% Histogram
[counts, edges] = histcounts(distances, binEdges);

% Plotting histogram
figure;
bar(edges(1:end-1), counts, 'histc');
xlabel('Distance from Center of Mass');
ylabel('Count');
title('Shape Histogram with 60 Shells');
axis tight;
grid on;

% sector 60 numbers

% numSectors = 60;
% Edgees = linspace(-pi, pi, numSectors + 1);
% 
% % Angles for sectors
% shift = Sampled_points - centroid;
% theta = atan2(shift(:,2), shift(:,1));
% 
% % Points in each sector
% sectorpts = histcounts(theta, Edgees);
% 
% % Histogram
% figure;
% bar(sectorpts);
% title('Point Distribution Across 60 Sectors');
% xlabel('Sector');
% ylabel('Count');
% axis tight;
% xticks(1:numSectors);
% xticklabels(arrayfun(@(x) sprintf('%d', x), 1:numSectors, 'UniformOutput', false));
% grid on;
% 
end
