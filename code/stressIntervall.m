function toggleStressIntervall(app, event)

	value = app.Switch.Value;
	if strcmp(value, 'On')
		% calculate height and width of stress intervall
		rectX = [app.StarttimeminEditField.Value, app.StarttimeminEditField.Value + app.LengthminEditField.Value];
		rectY = ylim(app.UIAxes);
		% add stress intervall to plot
		app.stressIntervall = patch(app.UIAxes, rectX([1,2,2,1]), rectY([1 1 2 2]), 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
		% reset limits of UIAxes to prevent layout issues
		ylim(app.UIAxes, rectY);
	else
		% delete stress intervall if switch is set to off
		delete(app.stressIntervall);
	end
end