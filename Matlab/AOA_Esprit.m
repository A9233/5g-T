clear all
format long %The data show that as long shaping scientific
doa=[20 60 65 70 75]/180*pi; %Direction of arrival
N=200;%Snapshots
w=[pi/4 pi/3]';%Frequency
M=10;%Number of array elements
P=length(w); %The number of signal
lambda=150;%Wavelength
d=lambda/2;%Element spacing
snr=20;%SNA
D=zeros(P,M); %To creat a matrix with P row and M column
for k=1:P
D(k,:)=exp(-j*2*pi*d*sin(doa(k))/lambda*[0:M-1]); %Assignment matrix
end
D=D';
xx=2*exp(j*(w*[1:N])); %Simulate signal
x=D*xx;
x=x+awgn(x,snr);%Insert Gaussian white noise
Rx=x*x'; %Data covarivance matrix
[V, D] = eig(Rx);
% sort eigenvectors in decreasing order of their eigenvalues:
[d,indices] = sort(diag(D), 'descend');
% D_sorted = D(indices, indices);
V_sorted = V(:,indices);
% extract first K eigenvectors (columns):
V1 = V_sorted(:, 1:K);

% W1 and W2 matrices:
W1 = V1(1:N-1, :);
W2 = V1(2:end, :);

% solve optomization by LS:
psi = inv(W1'*W1) * W1' * W2;

% perform eigendecomposition of psi:
[V_psi, D_psi] = eig(psi);

% extract theta_k's:
angles = angle(diag(D_psi));
sines = angles / (-2*pi*(dist/lambda));
thetas = asin(sines);
% convert to degrees:
thetas = (180/pi) * thetas;
disp(['the ESPRIT estimation result are: ',num2str(thetas')])
