function convertAbaqusToFlagshyp2(abaqusInputFile, flagshypOutputFile)
    % Load Abaqus data
    [nodes, elements] = parseAbaqusNodesElements(abaqusInputFile);
%    [nsets, bcInfo] = parseAbaqusBCsNsets(abaqusInputFile);

    % Process boundary conditions
 %   nodes = updateNodesWithBCs(nodes, nsets, bcInfo); 

    bcNodes = [1];
    % Write FLagSHyP input
    writeFlagshypInput(flagshypOutputFile, nodes, elements,bcNodes);
end

%-----------------------------------------------------
function [nodes, elements] = parseAbaqusNodesElements(filename)
    % Initialize empty matrices for nodes and elements
    nodes = [];
    elements = [];
    
    % Open the Abaqus input file for reading
    fid = fopen(filename, 'r');
    if fid == -1
        error(['Failed to open file: ' filename]);
    end
    
    % Flags indicating if we're currently reading nodes or elements
    readingNodes = false;
    readingElements = false;
    
    % Read the file line by line
    while ~feof(fid)
        tline = fgetl(fid); % Read the current line
        tline = strtrim(tline); % Trim whitespace from the line
        
        % Detect section headers and set flags
        if startsWith(tline, '*Node', 'IgnoreCase', true)
            readingNodes = true;
            readingElements = false;
        elseif startsWith(tline, '*Element', 'IgnoreCase', true)
            readingNodes = false;
            readingElements = true;
        elseif startsWith(tline, '*')
            % Any other section header encountered
            readingNodes = false;
            readingElements = false;
        end
        
        % Parse node data
        if readingNodes && ~startsWith(tline, '*')
            nodeData = sscanf(tline, '%f, %f, %f, %f'); % Expecting: NodeID, x, y, z
            if length(nodeData) == 4
                nodes = [nodes; nodeData']; % Add to nodes matrix
            end
        end
        
        % Parse element data
        if readingElements && ~startsWith(tline, '*')
            elementData = sscanf(tline, '%f,', [1, Inf]); % Expecting: ElementID, NodeIDs...
            elements = [elements; elementData']; % Add to elements matrix
        end
    end
    
    % Close the file after reading
    fclose(fid);
end





%-------------------------------------
function validName = sanitizeName(name)
    % Replace invalid characters with underscores
    validName = regexprep(name, '[^a-zA-Z0-9_]', '_');
    
    % Ensure the name starts with a letter
    if isempty(regexp(validName(1), '[a-zA-Z]', 'once'))
        validName = ['A_' validName];
    end
end



%-------------------------------------------------
function [nsets, bcInfo] = parseAbaqusBCsNsets(filename)
    % Initialize containers for nsets and boundary conditions information
    nsets = struct();
    bcInfo = struct();
    
    % Open the Abaqus input file for reading
    fid = fopen(filename, 'r');
    assert(fid ~= -1, 'Failed to open file.');
    
    % Initialize state flags and current nset name holder
    currentNsetName = '';
    parsingNset = false;  % Flag indicating if currently parsing an nset
    
    while ~feof(fid)
        line = strtrim(fgetl(fid));  % Read and trim the current line
        
        % Detect the start of nset section
        if startsWith(line, '*Nset', 'IgnoreCase', true)
            % Extract the name of the nset
            tokens = regexp(line, 'nset=(?<name>\w+)', 'names');
            if ~isempty(tokens)
                currentNsetName = tokens.name;
                nsets.(currentNsetName) = [];  % Initialize an empty array for this nset
                parsingNset = true;  % Set the flag to indicate parsing of an nset has started
            end
        elseif startsWith(line, '*') && parsingNset
            % A new section has started, so stop parsing the nset
            parsingNset = false;
        elseif parsingNset
            % Continue reading node IDs for the current nset
            nodeIDs = sscanf(line, '%f,')';  % Parse node IDs from the current line
            nsets.(currentNsetName) = [nsets.(currentNsetName), nodeIDs];
        end
        
        % Additional parsing logic for boundary conditions or other sections can be included here
    end
    
    % Close the file after reading is complete
    fclose(fid);
end



%------------------------------------------------------
function nodes = updateNodesWithBCs(nodes, nsets, bcInfo)
    % Initialize BC code column in nodes
    if size(nodes, 2) < 5
        nodes(:,5) = 7; % Default BC code, assuming '7' is for unconstrained nodes
    end
    
    for bcName = fieldnames(bcInfo)'
        bcDetails = bcInfo.(bcName{1});
        if isfield(nsets, bcDetails.nset)
            nsetNodes = nsets.(bcDetails.nset);
            for nodeId = nsetNodes
                nodeIdx = find(nodes(:, 1) == nodeId);
                if ~isempty(nodeIdx)
                    nodes(nodeIdx, 5) = bcDetails.bc; % Update BC code, customize logic as needed
                end
            end
        end
    end
end



%------------------------------------------------------
function bcNodes = resolveBCsToNodes(bcInfo, nsets)
    % Initialize a structure to hold the boundary condition for each node
    bcNodes = struct();
    
    % Iterate through each boundary condition in bcInfo
    bcNames = fieldnames(bcInfo);
    for i = 1:length(bcNames)
        bcName = bcNames{i};
        bcSet = bcInfo.(bcName);
        
        % For each BC, go through the defined node sets and assign the BC
        for j = 1:size(bcSet, 1)
            % Extract the node set name and BC details from bcSet
            % Assuming bcSet is structured with: [NsetID, BC details...]
            nsetName = bcSet{j, 1};
            bcDetails = bcSet{j, 2:end};
            
            % Check if the nset exists
            if isfield(nsets, nsetName)
                % Get the list of nodes for this nset
                nodesInSet = nsets.(nsetName);
                
                % For each node in the set, assign the BC details
                for k = 1:length(nodesInSet)
                    nodeName = ['Node_' num2str(nodesInSet(k))];
                    bcNodes.(nodeName) = bcDetails;
                end
            else
                warning(['Nset "' nsetName '" not found for BC: ' bcName]);
            end
        end
    end
end




function writeFlagshypInput(filename, nodes, elements, bcNodes)
    % Open file for writing
    fid = fopen(filename, 'w');
    if fid == -1
        error('Cannot open file %s for writing.', filename);
    end
    
    % Write header
    fprintf(fid, 'Example Problem\n');
    fprintf(fid, 'hexa8\n'); % Assuming all elements are hexa8 for this example
    
    % Write nodes
    fprintf(fid, '%d\n', size(nodes, 1));
    for i = 1:size(nodes, 1)
        % Placeholder for BC code; you'll need to adjust this based on actual BC data
        bcCode = 7; % Default to no boundary conditions applied
        if any(bcNodes == nodes(i, 1))
            bcCode = 0; % Example: setting BC code to 0 for simplicity
        end
        fprintf(fid, '%d %d %.6f %.6f %.6f\n', nodes(i, 1), bcCode, nodes(i, 2), nodes(i, 3), nodes(i, 4));
    end
    
    % Write elements
    fprintf(fid, '%d\n', size(elements, 1));
    for i = 1:size(elements, 1)
        fprintf(fid, '%d 1 ', elements(i, 1)); % Assuming material number 1 for all elements
        fprintf(fid, '%d ', elements(i, 2:end));
        fprintf(fid, '\n');
    end
    
    % Placeholder for writing materials (you'll need to adjust this part)
    fprintf(fid, '1\n'); % Number of materials
    fprintf(fid, '1 1 7800.0 76.92e9 115.4e9 NeoHooke\n'); % Example material properties
    
    % Placeholder for writing boundary conditions and loads (adjust as necessary)
    fprintf(fid, '0 0 0 0.0 0.0 0.0\n'); % Example with no loads and boundary conditions
    
    % Close file
    fclose(fid);
end

