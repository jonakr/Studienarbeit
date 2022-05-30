function savePlot(app, event)
	% this functions saves the plot to a given format
	% it can be called in the menu bar
	
	filter = {'*.jpg';'*.png';'*.tif';'*.pdf'};
	[filename,filepath] = uiputfile(filter);
	if ischar(filename)
		exportgraphics(app.UIAxes, [filepath filename]);
	end
end