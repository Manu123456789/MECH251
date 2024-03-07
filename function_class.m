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

        function D2_distribution_plot(obj, Sampled_points)
            % Implementation similar to the provided function
            % Using Sampled_points directly or obj.SampledPoints
        end

        function A3_distribution_plot(obj, Sampled_points)
            % Implementation similar to the provided function
            % Using Sampled_points directly or obj.SampledPoints
        end
    end
end
