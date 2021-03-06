function [ mean_face, faces_difference_vectors, eigen_faces_vectors_descend, eigen_values_descend ] = ... 
    create_eigenface_system( training_face_images_vectors )
    % Creates eigenface system from a set of training grayscale faces images.
    % Input:
    % @training_face_images_vectors - matrix where each column is a face
    % vector (face image matrix translated to vector by concatenating matrix rows)
    % Output:
    % @mean_face - average face vector created from training faces
    % @faces_difference_vectors - original face matrix but from each column
    % of it(from each face) a mean face is subtracted
    % @eigen_faces_vectors_descend - matrix that consists of eigen face 
    % vectors which are the same size as every training face vector. They
    % are sorted in ascending order relative to corresponding eigenvalues.
    % So that the most important eigenfaces come first.
    % @eigen_values_descend - eigenvalues related to eigenfaces. Also are
    % placed in the same order with corresponding eigenfaces vectors

    % Cast to double because because uint8 doesn't allow negative values
    % that can be obtained while subtracting mean value from them
    faces_difference_vectors = double( training_face_images_vectors );
    
    amount_of_faces_images = size(faces_difference_vectors, 2);
    size_of_face_vector = size(faces_difference_vectors, 1);
    
    mean_face = zeros(size_of_face_vector, 1, 'double');
    
    for i = 1:amount_of_faces_images
        mean_face = mean_face + faces_difference_vectors(:, i);
    end
    
    mean_face = mean_face / amount_of_faces_images;
    
    % Normalize other faces by subtracting the mean face. So that now expected
    % values for each variable(pixel in this case) is 0
    for i = 1:amount_of_faces_images
        faces_difference_vectors(:, i) = faces_difference_vectors(:, i) - mean_face;
    end
    
    % From this matrix eigenvalues and eigenvectors will be obtained
    covarience_replacement = faces_difference_vectors' * faces_difference_vectors;

    [eigen_vectors, eigen_values] = eig(covarience_replacement);

    % Sort eigenvalues in descending order, so that it will be easier to omit
    % vectors with small eigen values
    [eigen_values_descend, eigen_values_descend_index] = sort(diag( eigen_values ), 'descend');

    % Sort eigenvectors in the same way
    eigen_vectors = eigen_vectors(:, eigen_values_descend_index);

    % Obtain eigenvectors of covariance matrix
    eigen_faces_vectors_descend = faces_difference_vectors * eigen_vectors;

    % Normalize obtained vectors so that norm of each one is 1
    for i = 1:amount_of_faces_images
        eigen_faces_vectors_descend(:, i) = eigen_faces_vectors_descend(:, i) / norm(eigen_faces_vectors_descend(:, i));
    end

end

