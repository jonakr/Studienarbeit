function tempStruct = tableConverter(table)
    transposed = struct2cell(table');
    names = fieldnames(table)';
    tempStruct = struct();
    
    for idx = 1:length(names)
        theData = cell2mat(transposed(idx,:));
        tempStruct.(char(names(idx))) = theData;
    end
end