function ls = lifetimeSparseness(rates)
    % column vector or matrix
    
    if size(rates, 1) == 1
        rates = rates';
    end
    
    top = rates ./ repmat(size(rates, 1), size(rates));
    top = sum(top);
    top = top .* top;
    
    bottom = rates .* rates;
    bottom = bottom ./ repmat(size(rates, 1), size(rates));
    bottom = sum(bottom);
    
    ls = top ./ bottom;
    
    