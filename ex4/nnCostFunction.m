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
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
%       Part 1
a_X = [ones(m,1),X];        % m * 401

z_H = Theta1 * a_X';        % 25 * m

a_H = sigmoid(z_H);

a_H = [ones(1,m); a_H];     % 26 * m

z_Y = Theta2 * a_H;         % 10 * m

a_Y = sigmoid(z_Y);

y = y';  % 1 * m

yy = zeros(num_labels,m);

for j = 1:m
    yy( y(j), j) = 1;
end

y = yy;

J = (1/m) * sum(sum(   -y.* log(a_Y) - (1 - y).* log(1 - a_Y)   ));  

theta1 = Theta1(:,2:end);
theta2 = Theta2(:,2:end); % 10 * 26

J = J + (lambda/(2*m))* ( sum(sum( theta1.^2 )) + sum(sum( theta2.^2)));

%       Part 2
deta3 = a_Y - y;       % 10*m

temp = Theta2' * deta3;     %26 * m
deta2 = (temp(2:end,:)).* sigmoidGradient(z_H); % 25 * m

Deta1 = deta2 * a_X;        % 25 * 401 = 25*m  m*401
Deta2 = deta3 * a_H';        % 10 * 26

Theta1_grad = Deta1/m;
Theta2_grad = Deta2/m;

%       Part 3
Theta1_grad(:,2:end) = Theta1_grad(:,2:end) + (lambda/m) * theta1;
Theta2_grad(:,2:end) = Theta2_grad(:,2:end) + (lambda/m) * theta2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
