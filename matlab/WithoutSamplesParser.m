classdef WithSamplesParser

    properties
        path
        data
    end

    methods
        function obj = WithSamplesParser(path2file)
            obj.path = path2file;

            

            obj.data = load(path2file);
        end
    end
end