function Create_CSV(sampleLength,fileLength,sampleShift,filename)
    csvstr = filename + "," + "1" + ",";
    color = " # 0 255 0";

    starttime = 0;
    endtime = sampleLength*60;

    for i =1:(fileLength + 1 - sampleLength)
        csvstr = strcat(csvstr,"Sample",int2str(i),color,",",int2str(starttime),",",int2str(endtime),",");
        endtime = endtime + (sampleShift*60);
        starttime = starttime + (sampleShift*60); 
    end
    writematrix(csvstr, "Kubios_Samples.csv");
end

