function f = maxminmax_f57(x,y,z)
% Rastrigin-rastrigin-rastrigin function (Type 1)
% Global optimum value: f(0.1,0.1,0.1) = 0
%
% Property
% * Multimodal
% * xy-correlation: No
% * xz-correlation: No
% * yz-correlation: No
shift = 0.1;
if nargin == 0
	f = shift;
	return;
end

x = x - shift;
y = y - shift;
z = z - shift;
X = x;
Y = y;
Z = z;
a = 1;
b = 1;
c = 1;
f = - a * rastrigin(X) ...
	+ b * rastrigin(Y) ...
	- c * rastrigin(Z);
end
