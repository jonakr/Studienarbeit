tempMatrix = [];
cleanMSE = struct();
for idx = 1:length(obj.data.Res.HRV.NonLinear)
	tempMatrix = cat(1, tempMatrix, obj.data.Res.HRV.NonLinear(idx).MSE);
end
tempMatrix = tempMatrix';
for id = 1:size(tempMatrix, 1)
	[cleanMSE.(['MSE' num2str(id)])] = tempMatrix(id,:);
end