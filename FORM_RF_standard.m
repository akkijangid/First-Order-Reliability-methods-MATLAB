function [u_standard, beta, p_f] = FORM_RF_standard(g,variables_list)
%% Failure probability and the realibiliaty index using the HLRF method for standard limit state functions 
%{
MIT License

Copyright (c) 2020 Iago Pereira Lemos

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
---------------------------------------------------------------------------
Created by: Iago Pereira Lemos (lemosiago123@gmail.com)
Federal University of Uberlândia, School of mechanical engineering
---------------------------------------------------------------------------
Inputs
g: limit state function
variables_list: vector of symbolic variables in the limit state function

Outputs
u_standard: Coordinates of the design point in the standard space
beta: Reliability index value
p_f: Probability of failure
%}

%% initialization
tol     = 0.001;                %error
maxiter = 50;                   %maximum number of iterations
d       = length(variables_list)%number of variables in the l.s.f.
x       = ones(d,maxiter);      %initialization of the vector of design points
%% HLRF method
dg = gradient(g, variables_list);
k = 1;  %initializing the counter
while true
 
   dg_x_k      = subs(dg, variables_list, x(:,k));     %comuting the gradient of the l.s.f. in the k design point
   g_x_k       = subs(g, variables_list, x(:,k));      %computign the l.s.f value in the k design point
   norm_dg_x_k = norm(dg_x_k);                         %computing the norm of the grandient of l.s.f in the k design point
   
   
   % doing some maths
   esc_1      = 1/norm_dg_x_k^2; 
   esc_2      = (dg_x_k'*x(:,k) - g_x_k);
   esc_3      = esc_1 * esc_2;
   
   x(:,k+1)   = esc_3 * dg_x_k;
   
   % next iteration
   if (norm(x(:,k+1)-x(:,k)) <= tol)  || (norm_dg_x_k <= tol)
      break;
   else
      k = k+1;
   end
end


beta = norm(x(:,k));

n_iterations = k;
p_f = normcdf(-beta);
u_standard = x(:,k);

fprintf('Using the Rackwitz-Fiessler algorithm for standard limit state functions:\n');
fprintf('Iterations: %g\nReliability index = %g\nFailure probability = %g\n\n', n_iterations, beta, p_f);

return;
