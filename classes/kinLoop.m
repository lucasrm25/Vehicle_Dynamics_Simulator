classdef kinLoop < handle
    
    % f_S, q_S, s_S, s_S_0 - solve(q_S_val)
    
    properties
        f         % sym vector - loop functions
        q         % sym vector - main coordinates
        q_names   % char vector - main coordinates
        s         % sym vector - secondary coordinates
        s_0       % double vector - initial guess values
        K
        Kmain
        fun = 0
    end
    
    methods
        function obj = kinLoop(loop_functions, main_coord, secondary_coord, secondary_coord_init, varargin)
            if ~isempty(varargin) && strcmp(varargin{1},'fun')
                obj.f = matlabFunction(loop_functions,'Vars',{main_coord});
                obj.fun = 1;
            else
                obj.f = loop_functions;
            end
            obj.q       = main_coord;
            obj.q_names = cellfun(@char, sym2cell(obj.q),'UniformOutput', false);
            obj.s       = secondary_coord;
            obj.s_0     = secondary_coord_init;
        end

        function Kmatrix = jacobian(obj, varargin)
            if obj.fun
                obj.K = vpa(jacobian(obj.f(obj.q), obj.q));     % If loop function are Matlabfunctions, then each functions correspond to one secundary variable. so K = dS/dq
            else
                J_S = jacobian(obj.f,obj.s);                    % Otherwise, calculate in the traditional form
                B_S = -jacobian(obj.f,obj.q);
                obj.K = (J_S\B_S);                
            end
            if ~isempty(varargin) && varargin{1}
                obj.K = simplify(K_S);                    
            end
            Kmatrix = obj.K;
        end
        
        function s_val = solve(obj, q_val)
            if obj.fun
                s_val = obj.f(q_val);
            else
                toSolve = subs(obj.f, obj.q_names, q_val);
                obj.s_0 = double(struct2array(vpasolve(toSolve, obj.s, obj.s_0))');
                s_val = obj.s_0;
            end
        end
    end
    
end




