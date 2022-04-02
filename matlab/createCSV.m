function isCreated = createCSV(sampleStart, sampleLength, fileLength, ...
    sampleShift, filename, path)
    
    isCreated = true;

    if (isempty(filename))
        isCreated = false;
        return;
    end

    export = [filename,"1"];
    color = " # 0 255 0";
    configFile = fullfile(path, 'Kubios_Samples.csv');
    starttime = sampleStart * 60;
    endtime = starttime + sampleLength * 60;

    for i = 1:(floor(fileLength/sampleShift))
        if (endtime > fileLength * 60)
            break;
        end
        export = [ export "Sample" + i + color starttime endtime ];
        endtime = endtime + (sampleShift * 60);
        starttime = starttime + (sampleShift * 60);
    end
    try
        writematrix(export, configFile, 'Delimiter', 'comma')
    catch ME
        isCreated = false;
    end
end

