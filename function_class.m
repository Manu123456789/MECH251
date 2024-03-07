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

        function sampled_points = sample_surface(obj, num_samples)
            % Ensure obj.Vertices and obj.TriangulatedFaces are set
            vertices = obj.Vertices;
            triangulated_faces = obj.TriangulatedFaces;
            
            % Similar implementation as provided function...
            % Calculation of areas, sampling points etc.
            % At the end:
            obj.SampledPoints = sampled_points; % Store the sampled points in the object property
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
