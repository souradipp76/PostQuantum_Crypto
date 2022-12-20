function [pval, fMax] = test_periodicity(x, fmin)
% Test for signal periodicity using Fisher's g-statistics (see references
% below). Due to numerical limitations (large factorials) the p value can
% be calculated only for significant value (p<0.1). For larger p values the
% resultant p-value is 1.
% 
% syntax:
%   [pval, fMax] = test_periodicity(x)
% input:
%   x    - NxT - matrix of time series(N - time series, T - time samples).
%   fmin - (optional) - minimum freq in units of number of observed periods (minimum frequency x T)
% output:
%   pval - Nx1 - pvalue (pvalues higher than 0.1 are set to 1).
%   fMax - Nx1 - frequency of maximum power (even if insignificant) in
%                normalized units.
% References:
% Fisher. "Tests of Significance in Harmonic Analysis." 1929 Proc. R. Soc. vol. 125 no. 796 54-59 - http://bioinformatics.oxfordjournals.org/content/20/1/5.full.pdf
% http://www.mathworks.com/help/signal/ug/significance-testing-for-periodic-component.html\ - watch it, there is an bug there
T = size(x,2);
for i = 1:size(x,1)
%     fprintfstack('row %d/%d\n', i, size(x,1));
    [pxx,F] = periodogram(x(i,:),hamming(T),[],1); %Obtain the periodogram of the signal using periodogram. Exclude 0 and the Nyquist frequency (Fs/2) .
    if i==1
        nfft = length(pxx);
        Pxx = zeros(size(x,1), nfft);
        Pxx(1, :) = pxx;
    else
        Pxx(i, :) = pxx;
    end
end
if ~exist('fmin','var')
    fmin = 4;
end
Pxx = Pxx(:, fmin:end-1); %disregard zero and nyquist frequencies (see refrences above)
F = F(fmin:end-1);
% figure;
% plot(F,10*log10(Pxx));
N = size(Pxx,2);
pns = 0.1; % non significance thershold
gns =  fminsearch(@(fisher_g)(g_pval(fisher_g, N) - pns).^2,0.1); % finds the threshold in terms of g-fisher
[maxval,index] = max(Pxx,[],2);
fMax = F(index);
fisher_g = maxval./sum(Pxx, 2); % Fisher's g?statistic is the ratio of the maximum perioodgram value to the sum of all periodogram values.
pval = zeros(size(x,1),1);
pval(isnan(fisher_g)) = 1;
pval(fisher_g < gns) = 1;
left = find(fisher_g > gns);
for i = 1: length(left)
    j = left(i);
    pval(j) = g_pval(fisher_g(j), N);
end
function pval = g_pval(fisher_g, N)
    warning('OFF', 'MATLAB:nchoosek:LargeCoefficient');
    upper  = floor(1/fisher_g);
    I = zeros(upper,1);
    for p = 1:upper
        I(p) = (-1)^(p-1)*nchoosek(N,p)*(1-p*fisher_g)^(N-1);
        %I(p) = (-1)^(p-1)*factorial(N)/factorial(N-p)/factorial(p)*(1-p*fisher_g).^(N-1);
    end
    warning('ON', 'MATLAB:nchoosek:LargeCoefficient');
    pval = sum(I);