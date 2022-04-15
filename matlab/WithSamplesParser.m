classdef WithSamplesParser

    properties
        path
        data
        sampleLength
        minutesArray
    end

    methods
        function obj = WithSamplesParser(path2file)
            obj.path = path2file;
            obj.data = load(path2file);

            obj = obj.adjustDataStructure();

            % calculate the length of a single sample
            obj.sampleLength = floor((obj.data.Res.CNT.Length / 60) / obj.data.Res.HRV.Param.Nbr_Segment);

            obj.minutesArray = obj.sampleLength:obj.sampleLength:obj.data.Res.HRV.Param.Nbr_Segment * obj.sampleLength;
        end

        function plotToAxes(obj, setup, UIAxes, selectedVar, selectedGroup)
            
            if selectedGroup == "Time-Domain"
                setuplink = setup.variablesStruct.timeDomain;
                datalink = obj.data.Res.HRV.Statistics;
            elseif selectedGroup =="Frequency-Domain FFT spectrum"
                setuplink = setup.variablesStruct.frequencyDomain;
                datalink = obj.data.Res.HRV.Frequency.Welch;
            elseif selectedGroup =="Frequency-Domain AR spectrum"
                setuplink = setup.variablesStruct.frequencyDomain;
                datalink = obj.data.Res.HRV.Frequency.AR;
            elseif selectedGroup =="Nonlinear"
               setuplink = setup.variablesStruct.nonlinear;
               datalink = obj.data.Res.HRV.NonLinear;
            end

            idx = find(ismember({setuplink(:).index}, selectedVar));
            
            short = setuplink(idx).short;
            description = setuplink(idx).description;
            unit = setuplink(idx).unit;
            type = setuplink(idx).type;

            % plot data and adjust axis
            scatter(UIAxes, obj.minutesArray, datalink.(selectedVar), ...
                                                'MarkerEdgeColor',[0 .5 .5],...
                                                'MarkerFaceColor',[0 .7 .7],...
                                                'LineWidth',1.5);
            UIAxes.Title.String = short;
            UIAxes.Subtitle.String = description;
            UIAxes.YLabel.String = unit;
            UIAxes.XLabel.String = 'Minutes';
            ylim(UIAxes, 'padded');

        end

        function obj = adjustDataStructure(obj)
            % adjust the different data structs to match plotting scheme
            % warning! this deletes the other measurements if not copied
       
            % adjust statistics data
            cleanData = tableConverter(obj.data.Res.HRV.Statistics);
            cleanNested = nestedTableConverter(obj.data.Res.HRV.Statistics, ...
                'PRSA', {'DC_phase_ave', 'DC_phase_sd', 'DC_phase_sel_ave', ...
                'DC_phase_sel_sd','AC_phase_ave', 'AC_phase_sd', 'AC_phase_sel_ave', 'AC_phase_sel_sd'});
            namesStats = [fieldnames(cleanData); fieldnames(cleanNested);];
            obj.data.Res.HRV.Statistics = cell2struct([struct2cell(cleanData); struct2cell(cleanNested)], namesStats, 1);
            
            % adjust frequency data
            obj.data.Res.HRV.Frequency = struct( ...
                'Welch', nestedTableConverter(obj.data.Res.HRV.Frequency, 'Welch', {'F', 'PSD'}), ...
                'AR', nestedTableConverter(obj.data.Res.HRV.Frequency, 'AR', {'F', 'PSD', 'PSD_comp', 'PSD_comp_pow'}));            
            
            %adjust nonlinear data
            % clean data that isnt nested
            notNested = rmfield(obj.data.Res.HRV.NonLinear, {'MSE', 'DFA', 'CorDim', 'RPA', 'EnoughData'});
            cleanNotNested = tableConverter(notNested);
            % get nested DFA data
            cleanDFA = nestedTableConverter(obj.data.Res.HRV.NonLinear, 'DFA', {'N1', 'N2', 'xdata', 'ydata', 'th'});
            % get nested CorDim data
            cleanCorDim = nestedTableConverter(obj.data.Res.HRV.NonLinear, 'CorDim', {'log_r', 'log_C', 'th'}); 
            % get nested RPA data
            cleanRPA = nestedTableConverter(obj.data.Res.HRV.NonLinear, 'RPA', {'RP', 'Lhist'});
            % get nested MSE data
            tempMatrix = [];
            cleanMSE = struct();
            for idx = 1:length(obj.data.Res.HRV.NonLinear)
                tempMatrix = cat(1, tempMatrix, obj.data.Res.HRV.NonLinear(idx).MSE);
            end
            tempMatrix = tempMatrix';
            for id = 1:size(tempMatrix, 1)
                [cleanMSE.(['MSE' num2str(id)])] = tempMatrix(id,:);
            end
            % concat all structs
            namesNon = [fieldnames(cleanNotNested); fieldnames(cleanDFA); fieldnames(cleanCorDim); fieldnames(cleanRPA); fieldnames(cleanMSE)];
            obj.data.Res.HRV.NonLinear = cell2struct([struct2cell(cleanNotNested); ...
                struct2cell(cleanDFA); struct2cell(cleanCorDim); struct2cell(cleanRPA); struct2cell(cleanMSE)], namesNon, 1);
            
            % fix unit of all variables that should be represented in
            % milliseconds
            obj.data.Res.HRV.Statistics.RMSSD = obj.data.Res.HRV.Statistics.RMSSD * 1000;
            obj.data.Res.HRV.Statistics.mean_RR = obj.data.Res.HRV.Statistics.mean_RR * 1000;
            obj.data.Res.HRV.Statistics.std_RR = obj.data.Res.HRV.Statistics.std_RR * 1000;
            obj.data.Res.HRV.Statistics.TINN = obj.data.Res.HRV.Statistics.TINN * 1000;
            obj.data.Res.HRV.Statistics.DC = obj.data.Res.HRV.Statistics.DC * 1000;
            obj.data.Res.HRV.Statistics.DCmod = obj.data.Res.HRV.Statistics.DCmod * 1000;
            obj.data.Res.HRV.Statistics.AC = obj.data.Res.HRV.Statistics.AC * 1000;
            obj.data.Res.HRV.Statistics.ACmod = obj.data.Res.HRV.Statistics.ACmod * 1000;
            obj.data.Res.HRV.NonLinear.Poincare_SD1 = obj.data.Res.HRV.NonLinear.Poincare_SD1 * 1000;
            obj.data.Res.HRV.NonLinear.Poincare_SD2 = obj.data.Res.HRV.NonLinear.Poincare_SD2 * 1000;
        end
    end
end