function formatFigureForPaper

    fontSize = 7;
    screenPosition = [200 200 250 200];
    % in points 8.5 x 11 is 595 x 770
    paperPosition = [200 200 250 200];
    set(gca, 'TickDir', 'out');
    set(gcf, 'Position', screenPosition, 'PaperPosition', paperPosition);