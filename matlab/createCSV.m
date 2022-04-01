function createCSV(sampleStart, sampleLength, fileLength, ...
    sampleShift, filename)

    export = [filename,"1"];
    color = " # 0 255 0";
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
    writematrix(export,'Kubios_Samples.csv','Delimiter','comma')
end

