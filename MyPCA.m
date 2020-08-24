classdef MyPCA < handle
%
% DO Principle Component Analysis using Singular Value Decomposition.
% The input data of [MxN], M is dimension, N is sample number.
% This will whiten the datas in each principle dimension and get similar
% results as in sklearn.decomposition.PCA in Python.
% Parameters:
%       n_comp_: number of principle component;
%
    properties
        n_comp_;
        singular_vectors_;
        singular_values_;
        sample_means_
    end
    methods
        function sub_X = sub_mean(obj, X)
            obj.sample_means_ = mean(X,2);
            sub_X = bsxfun(@minus, X, obj.sample_means_);
        end
        function y = compute_trans(obj, X, n_comp)
            obj.n_comp_ = n_comp;
            sub_X = obj.sub_mean(X);
            [u,s,~] = svd(sub_X,'econ');
            n_samples = size(sub_X,2);
            obj.singular_vectors_ = u(:,1:obj.n_comp_);
            obj.singular_values_ = s(1:obj.n_comp_,1:obj.n_comp_);
            y = (obj.singular_values_\obj.singular_vectors_')*sub_X*sqrt(n_samples);
        end
        function yy = inver_trans(obj, X)
            assert(size(X,1)==obj.n_comp_);
            n_samples = size(X,2);
            yy = obj.singular_vectors_*obj.singular_values_*X/sqrt(n_samples);
            yy = bsxfun(@plus,yy,obj.sample_means_);
        end
    end
end