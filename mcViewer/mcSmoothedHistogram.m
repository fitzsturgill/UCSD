function out = mcSmoothedHistogram(data, binEdges, span, method)

    if nargin < 4
        method = 'sgolay';
    end
    
    if nargin < 3
        span = 5;
    end
    out =histc(data, binEdges);
    out = smooth(out, span, method);


    