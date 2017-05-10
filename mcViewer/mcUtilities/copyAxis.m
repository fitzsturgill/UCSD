function copyAxis(old, new)

    props = get(old);
    fields = fieldnames(props);
    exceptions = {'Parent', 'Position', 'OuterPosition'};
    for i = 1:length(fields)
        if strcmp(fields{i}, 'Children')
            copyobj(get(old, 'Children'), new);
        elseif any(strcmp(fields{i}, exceptions))
            continue
        else
            try
                set(new, fields{i}, props.(fields{i}))
            catch
            end
        end
    end