% Manu Bodagala
classdef GeometricObjectProcessor
    properties
        Vertices % Matrix of vertices coordinates
        TriangulatedFaces % Matrix of triangulated faces
        SampledPoints % Matrix of sampled points on the surface
    end

    methods
        function obj = GeometricObjectProcessor(vertices, triangulatedFaces)
            % Constructor to initialize with vertices and faces, if provided
            if nargin > 0
                obj.Vertices = vertices;
                obj.TriangulatedFaces = triangulatedFaces;
            end
        end

        function centroid = calculate_centroid(obj, node_xyz)
            x_avg = mean(node_xyz(1, :));
            y_avg = mean(node_xyz(2, :));
            z_avg = mean(node_xyz(3, :));
            centroid = [x_avg, y_avg, z_avg];
        end

        function translated_node_xyz = translate_to_centroid(obj, centroid, node_xyz)
            centroid = centroid(:); % Converting to column vector
            centroid_rep = repmat(centroid, 1, size(node_xyz, 2));
            translated_node_xyz = node_xyz - centroid_rep;
        end

    function sampled_points = sample_surface(vertices, triangulated_faces, num_samples)
    
        % Calculating the area of each triangle
        areas = zeros(1, size(triangulated_faces, 2)); % One area value per triangle
        for i = 1:size(triangulated_faces, 2) % Iterate through each triangle
            v1 = vertices(:, triangulated_faces(1, i)); % Vertex 1 of the i-th triangle
            v2 = vertices(:, triangulated_faces(2, i)); % Vertex 2 of the i-th triangle
            v3 = vertices(:, triangulated_faces(3, i)); % Vertex 3 of the i-th triangle
            a = norm(v2 - v1);
            b = norm(v3 - v2);
            c = norm(v1 - v3);
            s = 0.5 * (a + b + c);
            areas(i) = sqrt(s * (s - a) * (s - b) * (s - c)); % Heron's formula
        end
    
        % Computing the cumulative distribution function (CDF) for areas
        total_area = sum(areas);
        probs = areas / total_area;
        cdf = cumsum(probs);
    
        % Sampling points based on triangle areas
        sampled_points = zeros(num_samples, 3);
        for i = 1:num_samples
            r = rand(); % Random value for selecting triangle based on area
            triangle_index = find(cdf >= r, 1, 'first'); % Find the triangle to sample from
    
            % Get vertices for the selected triangle
            v1 = vertices(:, triangulated_faces(1, triangle_index));
            v2 = vertices(:, triangulated_faces(2, triangle_index));
            v3 = vertices(:, triangulated_faces(3, triangle_index));
    
            % Barycentric coordinates for random point inside triangle
            sqrt_r1 = sqrt(rand());
            r2 = rand();
            point = (1 - sqrt_r1) * v1 + (sqrt_r1 * (1 - r2)) * v2 + (sqrt_r1 * r2) * v3;
    
            sampled_points(i, :) = point;
        end
        end
    
        function normalized_node_xyz = normalize_object(obj, translated_node_xyz)
                n = size(translated_node_xyz, 2);
                s = sqrt(sum(sum(translated_node_xyz .^ 2)) / n);
                normalized_node_xyz = translated_node_xyz / s;
            end
    
            function aligned_node_xyz = align_with_principal_axes(obj, translated_node_xyz)
                [coeff, ~, ~] = pca(translated_node_xyz');
                aligned_node_xyz = coeff' * translated_node_xyz;
        end
    
        function D2_distribution_plot(Sampled_points)
            num_distances = 100000;  
        
            % Initialize distance array
            distances = zeros(num_distances, 1);
            
            for i = 1:num_distances
                % Randomly select Sampled_points
                indices = randperm(size(Sampled_points, 1), 2);
                p1 = Sampled_points(indices(1), :);
                p2 = Sampled_points(indices(2), :);
                
                % Euclidean dist
                distance = norm(p1 - p2);
                
                % Store the distance in the array
                distances(i) = distance;
            end
        
            figure;
            histogram(distances, 'Normalization', 'probability', 'BinWidth', 0.01); % Adjust BinWidth as needed
            xlabel('Distance');
            ylabel('Probability');
            title('D2 Distance Distribution');
        end
    
        function A3_distribution_plot(Sampled_points)
            % Define the number of angles to compute
            num_angles = 100000;  % You can adjust this number based on your needs, Manu
            
            % Preallocate array for angles
            angles = zeros(num_angles, 1);
            
            for i = 1:num_angles
                % Randomly select three unique rows from Sampled_points
                indices = randperm(size(Sampled_points, 1), 3);
                p1 = Sampled_points(indices(1), :);
                p2 = Sampled_points(indices(2), :);
                p3 = Sampled_points(indices(3), :);
                
                % Calculate the vectors between the points
                vec1 = p2 - p1;
                vec2 = p3 - p1;
                
                % Calculate the angle between the two vectors
                % Ensure the dot product does not exceed the range [-1, 1] due to numerical precision
                dot_product = max(min(dot(vec1, vec2) / (norm(vec1) * norm(vec2)), 1), -1);
                angle = acos(dot_product);
                
                % Store the angle in degrees in the array
                angles(i) = rad2deg(angle);
            end
            
            % Plot the distribution of angles
            figure;
            histogram(angles, 'Normalization', 'probability', 'BinWidth', 1);
            xlabel('Angle (degrees)');
            ylabel('Probability');
            title('A3 Angle Distribution');
            end
    end
end
