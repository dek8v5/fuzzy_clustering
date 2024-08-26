function[center,U,T,obj_fcn]= pfcm(data,cluster_n,options)
%pfcm Dataset clustering using possiblistic fuzzy c- %meansclustering.
%number of clusters in the data set DATA. 
%DATA is size M-by-N, where M is the number 
%of data points and N is the number of coordinates 
%for each datapoint. The coordinates for each 
%cluster center are returned in the rows of the 
%matrix CENTER. The membership function 
%matrix U contains the grade of membership of 
%each data point in each cluster. The values 0 and 
%1 indicate no membership and full membership 
%respectively. Grades between 0 and 1 indicate 
%that the data point has partial membership in a 
%cluster. At each iteration, a possiblistic degree

%same as in pcm T objective function is %minimized to find the best location for the %clusters and its values are returned in OBJ_FCN.
%[CENTER,..]=PFCM(DATA,N_CLUSTER,OPTIO %NS)specifies a vector of options fort he
%clustering process:
% OPTIONS(1): exponent for the matrixUdefault: %2.0)
% OPTIONS(2): maximum number of % iterations %(default: 100)
% OPTIONS(3): minimum amount of % improvement (default: 1e-5)
% OPTIONS(4): info display during % iteration (default: 1)
% OPTIONS(5): user defind constant a %(default: 1)
% OPTIONS(6): user defined constant b %should be greater than a (default:4)
% OPTIONS(7): user defined constant%nc (default:nc=2.0)
% The clustering process stops when the maximum % number of iterations is reached, or when %objective function improvement between two
% consecutiveiterations is less than the minimum % amount specified. Use NaN to select the default % value.See also pinitf, tinitf, pdistfcm,pstepfcm ifnargin ~= 2 &nargin ~= 3,

[CENTER,U,OBJ_FCN]=FCM(DATA, N_CLUSTER) %findsN_CLUSTER

error('Too many or too few input arguments!');
end data_n = size(data, 1);
in_n = size(data, 2);
% Change the following to set default options
default_options = [2;100;1e-;1;1;4;2];
ifnargin == 2,options = default_options;
else
% If "options" is not fully specified, pad it with
% default values.
if length(options) < 7,
tmp = default_options;
tmp(1:length(options)) = options;options = tmp;
end
% If some entries of "options" are nan's, replace them % with defaults.
nan_index = find(isnan(options)==1); options(nan_index) = default_options(nan_index); if options(1) <= 1,
error('The exponent should be greater than 1!'); end
end
expo = options(1);
max_iter = options(2);
min_impro = options(3);
display = options(4);
a=options(5);
b=options(6);
nc =options(7);
ni=input('enter value of ni');
obj_fcn = zeros(max_iter, 1);
% Array for objective function
center = input('initialize the centre');
U = pinitf(cluster_n, data_n); % Initial fuzzy partition
T = tinitf(cluster_n,data_n); % Initial typicality matrix
for i = 1:max_iter,
[U,T,center, obj_fcn(i)] = pstepfcm(data,center,U,T,cluster_n, expo,a,b,nc,ni);
if display,
fprintf('Iteration count = %d, obj. fcn = %f\n', i,
obj_fcn(i));
end
% check termination condition
if i > 1,
if abs(obj_fcn(i) - obj_fcn(i-1)) <min_impro,break;
end,
endenditer_n = i; % Actual number of terations obj_fcn(iter_n+1:max_iter) = [];