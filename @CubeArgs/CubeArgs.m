classdef CubeArgs < inputParser
% inputParser subclass for Cube argument parsing

    properties (Constant)
        CUBECLASSNAME = 'Cube'
    end

    methods
        function CA = CubeArgs()
            CA@inputParser;
            
            % Set these explicitly just to be clear
            CA.CaseSensitive   = false;
            CA.KeepUnmatched   = false;
            CA.PartialMatching = true;
            CA.StructExpand    = true;
            
            %% Required arguments
            
            dataValid = @(x)assert(CA.isDataSource(x),...
                'Data source must be a data array or a Cube object');
            CA.addRequired('data', dataValid);
            
            %% Optional name-value parameters
            
            qtyValid = @(x)assert(CA.isValidQuantity(x),...
                'Quantity must be a non-empty char array');
            CA.addParameter('quantity', 'Unknown', qtyValid);
           
            fileValid = @(x)assert(CA.isFile(x),...
                'Filename must be a valid path to an existing file');
            CA.addParameter('file', '', fileValid);
            
            WLValid = @(x)assert(CA.isValidWL(x),...
                'Wavelength specification must be a numeric vector');
            CA.addParameter('wl', [], WLValid);
            
            WLuValid = @(x)assert(CA.isValidWLu(x),...
                'Wavelength unit must be a non-empty char array');
            CA.addParameter('wlunit', '', WLuValid);
            
            fwhmValid = @(x)assert(CA.isValidFWHM(x),...
                'FWHM specification must be a numeric vector');
            CA.addParameter('fwhm', [], fwhmValid);
            
            historyValid = @(x)assert(CA.isValidHistory(x),...
                'History entries must be contained in a 1x1 cell array');
            CA.addParameter('history', {}, historyValid);
        end
        
    end
    
    methods (Static)
        %% Validation functions
        % Return a logical value
        
        function bool = isFile(x)
            bool = ischar(x) && ( exist(x,'file') == 2 );
        end
        
        function bool = isCube(x)
            bool = isa(x,CubeArgs.CUBECLASSNAME);
        end
        
        function bool = isDataSource(x)
            bool = CubeArgs.isCube(x) || isnumeric(x);
        end
        
        function bool = isValidQuantity(x)
            bool = ~isempty(x) && ischar(x);
        end
        
        function bool = isValidWL(x)
            bool = isnumeric(x) && isvector(x);
        end
        
        function bool = isValidWLu(x)
            bool = ~isempty(x) && ischar(x);
        end
        
        function bool = isValidFWHM(x)
            bool = isnumeric(x) && isvector(x);
        end
        
        function bool = isValidHistory(x)
            bool = iscell(x) && isequal(size(x), [1, 1]);
        end
    end
    
end