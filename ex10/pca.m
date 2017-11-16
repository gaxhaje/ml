close all; clear all;

load rawdata.mat;
X = normalize(rawdata);

# compute covariance for both; rawdata, X.
cov_rawdata = cov(rawdata);
cov_X = cov(X);

#figure 1;
#imagesc(cov_rawdata);
#colormap('gray');
#colorbar;

#figure 2;
#imagesc(cov_X);
#colormap('gray');
#colorbar;

# get eigen decomposition of our noermalized (zero-mean) data
[U S] = eigs(cov_X, 1024);

# sort the diagonal of 'S' 
[S_diag sorted_idx] = sort(diag(S), 'descend');
U = U(:,sorted_idx);

#figure 3;
#plot(S_diag);

# plot semilog 
#figure 4;
#semilogx(S_sorted);

# diagonalize the covariance matrix and compare is equal. 
D = U'*cov_X*U;
D_daig = diag(D);

#figure 5;
#plot(D_daig);

# compute SVD to decompose the zero-mean data into U, S, V matrices.
[U2, S2, V] = svd(cov_X);
S2_diag = diag(S2);

# calculate variance
for i = i:1024
  ratio = sum(S2_diag(1:i))/sum(S2_diag);
  if (ratio >= .99)
    break;
  endif
endfor

k=i;

X_reduced = X*U(:, 1:k);
sum(var(X))
sum(var(X_reduced))