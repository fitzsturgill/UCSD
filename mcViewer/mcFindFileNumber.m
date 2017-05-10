function s=mcFindFileNumber(filename)
        i1 = strfind(filename, '_');
        i2 = strfind(filename, '.');
        s = filename(i1(end)+1:i2-1);