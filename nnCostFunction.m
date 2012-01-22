function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

ty = zeros(size(y,1), num_labels);
for i =  1:size(y,1)
	ty(i, y(i)) = 1;
end;

a1 = [ones(m, 1) X];

z2 = (a1 * Theta1');
a2 = sigmoid(z2);
a2 = [ones(size(a2, 1),1) a2];

z3 = (a2 * Theta2');
a3 = sigmoid(z3);

hyp = a3;



reg1 = Theta1;
reg1(:, 1) = 0;
reg2 = Theta2;
reg2(:, 1) = 0;
reg_term = (lambda / (2 * m)) * (sum(sum(reg1 .^2, 2)) + sum(sum(reg2 .^2, 2)));


t1 = -ty .* log(hyp);
t2 = (1 - ty) .* log(1 - hyp);
%J = sum((1 / m) * sum(t1 - t2)) ;
J = sum((1 / m) * sum(t1 - t2)) + reg_term;




%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
% 
aaa = Theta1;
aaa(:,1) = 0;
theta1_reg_term = (lambda / m) * aaa;
bbb = Theta2;
bbb(:,1) = 0;
theta2_reg_term = (lambda / m) * bbb;

% size(Theta1)
% size(theta1_reg_term)
% size(Theta2)
% size(theta2_reg_term)

# g3 = 5000 x 10, which is fine, can't change that
# need / want a2 to be 5000 x 26 so that g3' * a2 ends up a 10 x 26 matrix, for theta2_grad
g3 = hyp - ty;
Theta2_grad = g3' * a2;
Theta2_grad = Theta2_grad / m;
Theta2_grad = Theta2_grad + theta2_reg_term;

# Theta2 is 10 x 26, which is fine, can't change that

# a1 is 5000x401, theta1 is 
bar = [zeros(size(z2,1),1) z2];
g2 = (g3 * Theta2) .* sigmoidGradient(bar);
Theta1_grad = (g2(:, 2:end))' * a1;
Theta1_grad = Theta1_grad / m;
Theta1_grad = Theta1_grad + theta1_reg_term;

%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%





% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
