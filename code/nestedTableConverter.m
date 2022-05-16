function cleanTable = nestedTableConverter(obj, table, column, structToRemove)
	tempStruct = rmfield(table(1).(column), structToRemove);
	
	for idx = 2:length(table)
		tempStruct = [tempStruct; rmfield(table(idx).(column), structToRemove)];
	end
	
	cleanTable = obj.tableConverter(tempStruct);
end