% calculate the length of a single sample
obj.sampleLength = floor((obj.data.Res.CNT.Length / 60) / obj.data.Res.HRV.Param.Nbr_Segment);
% convert into an array to use it in the plot later
obj.minutesArray = obj.sampleLength:obj.sampleLength:obj.data.Res.HRV.Param.Nbr_Segment * obj.sampleLength;