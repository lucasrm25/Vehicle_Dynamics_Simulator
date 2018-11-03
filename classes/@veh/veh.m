classdef veh < matlab.mixin.Copyable  

% Considerations:
%
% S are considered as LPV parameters, i.e. constants in relation to derivatives
% => dK/ds = 0
%
%
% TO DO:
%
%   Funcao diff2 deveria ser chamada de JACOBIAN2...
%   tambem deveria retornar uma matrix 1.X ao inves de X.1
%   e por ultimo, pode-se automatizar isso nesse codigo pra possibilitar a
%   multiplicacao destas celulas por matrizes e evitar o loop do Lagrange
%
% To implement:
%
% dK/dt = 0   (more radical)
%
%   that is: all S_dq_XXX = 0
%
%   POSSIVEL SOLUCAO... DEIXAR MATRIZES K e L COMO FUNCOES E NAO
%   CALCULAR AGORA POIS DEMORA MUITO E DEPOIS O PROGRAMA TENTA
%   DERIVAR ESSAS MATRIZES ENORMES...
%
%   OUTRA POSSIVEL SOLUCAO... CONSIDERAR dK/dt = 0.. ou seja
%   derivadas temporais das matrizes K como nulas... na verdade
%   eh a mesma solucao a cima.. ja que matrizes K e L se
%   tornariam agora "constantes"
%
%   PODEMOS CONFERIR qual a taxa de variacao dK/dt plotando na tela
%   Ou seja... comparar o efeito de dK/dt * qp e K * qpp

    
    
%% Properties
    properties
        DNA
        sus_fl
        sus_fr
        sus_rl
        sus_rr
        
        q
        q_red
        
        dynamicFunction
    end
    properties (GetAccess=private)
    end
    properties (Constant)
        grav = [0 0 -9.81]';
    end
    properties (Dependent)
    end

%% Methods    
    methods(Static)
    end
    methods
        function obj = veh(DNA, veh_sus_fl, veh_sus_fr, veh_sus_rl, veh_sus_rr)
            if isa(veh_sus_fl,'veh_sus') && isa(veh_sus_fl,'veh_sus') && isa(veh_sus_fl,'veh_sus') && isa(veh_sus_fl,'veh_sus')
                obj.sus_fl = veh_sus_fl;
                obj.sus_fr = veh_sus_fr;
                obj.sus_rl = veh_sus_rl;
                obj.sus_rr = veh_sus_rr;
            else
                error('Wrong class type for the suspensions')
            end
            obj.DNA = DNA;
        end

        function sim(obj, q0, qp0) %#ok<INUSD>
%             https://www.mathworks.com/help/symbolic/equation-solving.html
%             https://www.mathworks.com/help/symbolic/equation-solving.html
%             https://www.mathworks.com/help/symbolic/solve-differential-algebraic-equations.html

%                     q_tm1  = [0 0 pi/4   10 10 10  obj.sus_fl.init.LAUR_0(3) obj.sus_fr.init.LAUR_0(3) obj.sus_rl.init.LAUR_0(3) obj.sus_rr.init.LAUR_0(3)  0 0];
%                     qp_tm1 = [0 0 0 0 0 0 0 0 0 0 0 0];

%             e_fl_Ftyre = [0 0 tyr.stiffness*(tyr.compressionLength-v_fl_TYRO(3))*(v_fl_TYRO(3)<tyr.compressionLength)];
%             e_fr_Ftyre = [0 0 tyr.stiffness*(tyr.compressionLength-v_fr_TYRO(3))*(v_fr_TYRO(3)<tyr.compressionLength)];
%             e_rl_Ftyre = [0 0 tyr.stiffness*(tyr.compressionLength-v_rl_TYRO(3))*(v_rl_TYRO(3)<tyr.compressionLength)];
%             e_rr_Ftyre = [0 0 tyr.stiffness*(tyr.compressionLength-v_rr_TYRO(3))*(v_rr_TYRO(3)<tyr.compressionLength)];
        end
        
        function calculateDynamics(obj)
            
            % Reshape functions
            obj.sus_fl.reshape(12,[7  11]);
            obj.sus_fr.reshape(12,[8  11]);
            obj.sus_rl.reshape(12,[9  12]);
            obj.sus_rr.reshape(12,[10 12]);

            obj.sus_fl.set_prefix('fl_');
            obj.sus_fr.set_prefix('fr_');
            obj.sus_rl.set_prefix('rl_');
            obj.sus_rr.set_prefix('rr_');
            
            fprintf('Initializing Dynamics...\n')
            
            % Tyre reaction forces at the tyre contact point - Inertial CO
            e_fl_Ftyre = sym('e_fl_Ftyre_%d', [3 1]);
            e_fr_Ftyre = sym('e_fr_Ftyre_%d', [3 1]);
            e_rl_Ftyre = sym('e_rl_Ftyre_%d', [3 1]);
            e_rr_Ftyre = sym('e_rr_Ftyre_%d', [3 1]);
            
            syms e_ang_phi(t) e_ang_teta(t) e_ang_psi(t)      e_pos_x(t) e_pos_y(t) e_pos_z(t)
            syms v_fl_LAUR_3(t) v_fr_LAUR_3(t) v_rl_LAUR_3(t) v_rr_LAUR_3(t)
            syms v_fl_bSR(t) v_fr_bSR(t)
            q     = [e_ang_phi e_ang_teta e_ang_psi e_pos_x e_pos_y e_pos_z v_fl_LAUR_3 v_fr_LAUR_3 v_rl_LAUR_3 v_rr_LAUR_3 v_fl_bSR v_fr_bSR].'; %#ok<*PROP>
            q     = q(t);       % Convert symfun to syms array
            qp    = diff(q,t);
            qpp   = diff(qp,t);

            % Jacobian Matrix - vehicle CO to inertial CO
            e_T_v =  [cos(e_ang_psi)*cos(e_ang_teta) -sin(e_ang_psi)*cos(e_ang_phi)+cos(e_ang_psi)*sin(e_ang_teta)*sin(e_ang_phi)  sin(e_ang_psi)*sin(e_ang_phi)+cos(e_ang_psi)*sin(e_ang_teta)*cos(e_ang_phi);
                      sin(e_ang_psi)*cos(e_ang_teta)  cos(e_ang_psi)*cos(e_ang_phi)+sin(e_ang_psi)*sin(e_ang_teta)*sin(e_ang_phi) -cos(e_ang_psi)*sin(e_ang_phi)+sin(e_ang_psi)*sin(e_ang_teta)*cos(e_ang_phi);
                     -sin(e_ang_teta)                 cos(e_ang_teta)*sin(e_ang_phi)                                               cos(e_ang_teta)*cos(e_ang_phi)];

            e_T_v_dq = diff2(e_T_v,q);

            % Vehicle angular velocity - vehicle CO
            v_angp   = [-sin(e_ang_teta)                0               1;
                        cos(e_ang_teta)*sin(e_ang_phi)  cos(e_ang_phi)  0;
                        cos(e_ang_teta)*cos(e_ang_phi) -sin(e_ang_phi)  0] ...
                        * [diff(e_ang_psi) diff(e_ang_teta) diff(e_ang_phi)].';
            v_angpp    = diff(v_angp);
            v_angp_dq  = diff2(v_angp,q);
            v_angp_dqp = diff2(v_angp,qp);

            % Vehicle position - Inertial CO
            e_pos      = [e_pos_x e_pos_y e_pos_z].';
            e_pos_dq   = diff2(e_pos,q);
            e_posp     = diff(e_pos);
            e_posp_dq  = diff2(e_posp,q);
            e_posp_dqp = diff2(e_posp,qp);
            e_pospp    = diff(e_posp);

            % Get symbolic names with respective suspension prefix
            v_fl_TYRO = [obj.sus_fl.s_prefix.TYRO_1 obj.sus_fl.s_prefix.TYRO_2 obj.sus_fl.s_prefix.TYRO_3].';
            v_fr_TYRO = [obj.sus_fr.s_prefix.TYRO_1 obj.sus_fr.s_prefix.TYRO_2 obj.sus_fr.s_prefix.TYRO_3].';
            v_rl_TYRO = [obj.sus_rl.s_prefix.TYRO_1 obj.sus_rl.s_prefix.TYRO_2 obj.sus_rl.s_prefix.TYRO_3].';
            v_rr_TYRO = [obj.sus_rr.s_prefix.TYRO_1 obj.sus_rr.s_prefix.TYRO_2 obj.sus_rr.s_prefix.TYRO_3].';
            v_fl_cWH  = [obj.sus_fl.s_prefix.cWH_1 obj.sus_fl.s_prefix.cWH_2 obj.sus_fl.s_prefix.cWH_3].';
            v_fr_cWH  = [obj.sus_fr.s_prefix.cWH_1 obj.sus_fr.s_prefix.cWH_2 obj.sus_fr.s_prefix.cWH_3].';
            v_rl_cWH  = [obj.sus_rl.s_prefix.cWH_1 obj.sus_rl.s_prefix.cWH_2 obj.sus_rl.s_prefix.cWH_3].';
            v_rr_cWH  = [obj.sus_rr.s_prefix.cWH_1 obj.sus_rr.s_prefix.cWH_2 obj.sus_rr.s_prefix.cWH_3].';
            v_fl_bDS    = obj.sus_fl.s_prefix.bDS;
            v_fr_bDS    = obj.sus_fr.s_prefix.bDS;
            v_rl_bDS    = obj.sus_rl.s_prefix.bDS;
            v_rr_bDS    = obj.sus_rr.s_prefix.bDS;

            % Calculate K and L matrices
            v_fl_cWH_dq = sym('v_fl_cWH_dq',[3,12]);
            v_fr_cWH_dq = sym('v_fr_cWH_dq',[3,12]);
            v_rl_cWH_dq = sym('v_rl_cWH_dq',[3,12]);
            v_rr_cWH_dq = sym('v_rr_cWH_dq',[3,12]);          
% % %             v_fl_cWH_dq =  [ obj.sus_fl.reshapefun(obj.sus_fl.Kmatrix.cWH_1, q, struct2array(obj.sus_fl.s_prefix).') ;
% % %                              obj.sus_fl.reshapefun(obj.sus_fl.Kmatrix.cWH_2, q, struct2array(obj.sus_fl.s_prefix).') ;
% % %                              obj.sus_fl.reshapefun(obj.sus_fl.Kmatrix.cWH_3, q, struct2array(obj.sus_fl.s_prefix).') ];
% % %             v_fr_cWH_dq =  [ obj.sus_fr.reshapefun(obj.sus_fr.Kmatrix.cWH_1, q, struct2array(obj.sus_fr.s_prefix).') ;
% % %                              obj.sus_fr.reshapefun(obj.sus_fr.Kmatrix.cWH_2, q, struct2array(obj.sus_fr.s_prefix).') ;
% % %                              obj.sus_fr.reshapefun(obj.sus_fr.Kmatrix.cWH_3, q, struct2array(obj.sus_fr.s_prefix).') ];
% % %             v_rl_cWH_dq =  [ obj.sus_rl.reshapefun(obj.sus_rl.Kmatrix.cWH_1, q, struct2array(obj.sus_rl.s_prefix).') ;
% % %                              obj.sus_rl.reshapefun(obj.sus_rl.Kmatrix.cWH_2, q, struct2array(obj.sus_rl.s_prefix).') ;
% % %                              obj.sus_rl.reshapefun(obj.sus_rl.Kmatrix.cWH_3, q, struct2array(obj.sus_rl.s_prefix).') ];
% % %             v_rr_cWH_dq =  [ obj.sus_rr.reshapefun(obj.sus_rr.Kmatrix.cWH_1, q, struct2array(obj.sus_rr.s_prefix).') ;
% % %                              obj.sus_rr.reshapefun(obj.sus_rr.Kmatrix.cWH_2, q, struct2array(obj.sus_rr.s_prefix).') ;
% % %                              obj.sus_rr.reshapefun(obj.sus_rr.Kmatrix.cWH_3, q, struct2array(obj.sus_rr.s_prefix).') ];
            v_fl_cWH_ddq = diff2(v_fl_cWH_dq,q);
            v_fr_cWH_ddq = diff2(v_fr_cWH_dq,q);
            v_rl_cWH_ddq = diff2(v_rl_cWH_dq,q);
            v_rr_cWH_ddq = diff2(v_rr_cWH_dq,q);
   
            v_fl_bDS_dq = sym('v_fl_bDS_dq',[1,12]);
            v_fr_bDS_dq = sym('v_fr_bDS_dq',[1,12]);
            v_rl_bDS_dq = sym('v_rl_bDS_dq',[1,12]);
            v_rr_bDS_dq = sym('v_rr_bDS_dq',[1,12]);
% % %             v_fl_bDS_dq =  obj.sus_fl.reshapefun(obj.sus_fl.Kmatrix.bDS, q, struct2array(obj.sus_fl.s_prefix).') ;
% % %             v_fr_bDS_dq =  obj.sus_fr.reshapefun(obj.sus_fr.Kmatrix.bDS, q, struct2array(obj.sus_fr.s_prefix).') ;
% % %             v_rl_bDS_dq =  obj.sus_rl.reshapefun(obj.sus_rl.Kmatrix.bDS, q, struct2array(obj.sus_rl.s_prefix).') ;
% % %             v_rr_bDS_dq =  obj.sus_rr.reshapefun(obj.sus_rr.Kmatrix.bDS, q, struct2array(obj.sus_rr.s_prefix).') ;
  
            v_fl_TYRO_dq = sym('v_fl_TYRO_dq',[3,12]);
            v_fr_TYRO_dq = sym('v_fr_TYRO_dq',[3,12]);
            v_rl_TYRO_dq = sym('v_rl_TYRO_dq',[3,12]);
            v_rr_TYRO_dq = sym('v_rr_TYRO_dq',[3,12]);
% % %             v_fl_TYRO_dq = [ obj.sus_fl.reshapefun(obj.sus_fl.Kmatrix.TYRO_1,q,struct2array(obj.sus_fl.s_prefix).') ;
% % %                              obj.sus_fl.reshapefun(obj.sus_fl.Kmatrix.TYRO_2,q,struct2array(obj.sus_fl.s_prefix).') ;
% % %                              obj.sus_fl.reshapefun(obj.sus_fl.Kmatrix.TYRO_3,q,struct2array(obj.sus_fl.s_prefix).') ];
% % % 
% % %             v_fr_TYRO_dq = [ obj.sus_fr.reshapefun(obj.sus_fr.Kmatrix.TYRO_1,q,struct2array(obj.sus_fr.s_prefix).') ;
% % %                              obj.sus_fr.reshapefun(obj.sus_fr.Kmatrix.TYRO_2,q,struct2array(obj.sus_fr.s_prefix).') ;
% % %                              obj.sus_fr.reshapefun(obj.sus_fr.Kmatrix.TYRO_3,q,struct2array(obj.sus_fr.s_prefix).') ];
% % % 
% % %             v_rl_TYRO_dq = [ obj.sus_rl.reshapefun(obj.sus_rl.Kmatrix.TYRO_1,q,struct2array(obj.sus_rl.s_prefix).') ;
% % %                              obj.sus_rl.reshapefun(obj.sus_rl.Kmatrix.TYRO_2,q,struct2array(obj.sus_rl.s_prefix).') ;
% % %                              obj.sus_rl.reshapefun(obj.sus_rl.Kmatrix.TYRO_3,q,struct2array(obj.sus_rl.s_prefix).') ];
% % % 
% % %             v_rr_TYRO_dq = [ obj.sus_rr.reshapefun(obj.sus_rr.Kmatrix.TYRO_1,q,struct2array(obj.sus_rr.s_prefix).') ;
% % %                              obj.sus_rr.reshapefun(obj.sus_rr.Kmatrix.TYRO_2,q,struct2array(obj.sus_rr.s_prefix).') ;
% % %                              obj.sus_rr.reshapefun(obj.sus_rr.Kmatrix.TYRO_3,q,struct2array(obj.sus_rr.s_prefix).') ];


            % Calculate auxiliary variables for the Lagrange formulation
            e_fl_cWHp = e_posp   + e_T_v * ( v_fl_cWH_dq  * qp + cross(v_angp,v_fl_cWH) );
            e_fr_cWHp = e_posp   + e_T_v * ( v_fr_cWH_dq  * qp + cross(v_angp,v_fr_cWH) );
            e_rl_cWHp = e_posp   + e_T_v * ( v_rl_cWH_dq  * qp + cross(v_angp,v_rl_cWH) );
            e_rr_cWHp = e_posp   + e_T_v * ( v_rr_cWH_dq  * qp + cross(v_angp,v_rr_cWH) );
            e_CGp     = e_posp   + e_T_v * (                     cross(v_angp,obj.DNA.CG_s) ); 

            e_angp     = e_T_v * v_angp;
            e_angp_dq  = diff2(e_angp,q);
            e_angp_dqp = diff2(e_angp,qp);            
            
            
            % Calculation o the dd/dt^2 of each S (secondary coordinates)
            %   obs: we are ignoring de partial derivative in relation to S
            %        because or we disconsider its partial derivative or
            %        the diff only sees q as (t) dependent
            v_fl_cWHpp = v_fl_cWH_dq * qpp; %%%%% + cellsum(cellfun(@(a,b) a*b, v_fl_cWH_ddq, sym2cell(qp), 'UniformOutput', false)) * qp;   % or diff(K*qp, t)
            v_fr_cWHpp = v_fr_cWH_dq * qpp; %%%%% + cellsum(cellfun(@(a,b) a*b, v_fr_cWH_ddq, sym2cell(qp), 'UniformOutput', false)) * qp;
            v_rl_cWHpp = v_rl_cWH_dq * qpp; %%%%% + cellsum(cellfun(@(a,b) a*b, v_rl_cWH_ddq, sym2cell(qp), 'UniformOutput', false)) * qp;
            v_rr_cWHpp = v_rr_cWH_dq * qpp; %%%%% + cellsum(cellfun(@(a,b) a*b, v_rr_cWH_ddq, sym2cell(qp), 'UniformOutput', false)) * qp;           
            e_T_v_p    = simplify(diff(e_T_v, t));      
            v_fl_cWH_dq_p = diff(v_fl_cWH_dq, t);
            v_fr_cWH_dq_p = diff(v_fr_cWH_dq, t);
            v_rl_cWH_dq_p = diff(v_rl_cWH_dq, t);
            v_rr_cWH_dq_p = diff(v_rr_cWH_dq, t);
            e_angpp = diff(e_angp, t);            
            v_angp_dqp_p  = cellfun(@diff, v_angp_dqp, 'UniformOutput', false);     % function of Q only. Not S dependent
            e_angp_dqp_p  = cellfun(@diff, e_angp_dqp, 'UniformOutput', false);     % first part of v_fl_cWHpp can be also defined as this equation


            e_fl_cWHpp = e_pospp + e_T_v * ( cross(v_angpp,v_fl_cWH) + cross(v_angp,cross(v_angp,v_fl_cWH)) + 2*cross(v_angp,v_fl_cWH_dq*qp) + v_fl_cWHpp );
            e_fr_cWHpp = e_pospp + e_T_v * ( cross(v_angpp,v_fr_cWH) + cross(v_angp,cross(v_angp,v_fr_cWH)) + 2*cross(v_angp,v_fr_cWH_dq*qp) + v_fr_cWHpp );
            e_rl_cWHpp = e_pospp + e_T_v * ( cross(v_angpp,v_rl_cWH) + cross(v_angp,cross(v_angp,v_rl_cWH)) + 2*cross(v_angp,v_rl_cWH_dq*qp) + v_rl_cWHpp );
            e_rr_cWHpp = e_pospp + e_T_v * ( cross(v_angpp,v_rr_cWH) + cross(v_angp,cross(v_angp,v_rr_cWH)) + 2*cross(v_angp,v_rr_cWH_dq*qp) + v_rr_cWHpp );

            e_CGpp     = e_pospp + e_T_v * ( cross(v_angpp,obj.DNA.CG_s) + cross(v_angp,cross(v_angp,obj.DNA.CG_s)) );

            
            fprintf('    Calculating differential equations...\n'); tic;
            if isempty(gcp('nocreate')) parpool(4); end %#ok<*SEPEX>
            parfor_progress(pwd,numel(q));
            
            % avoid parfor overhead
            grav = obj.grav;
            DNA = obj.DNA;
            sus_fl.init = obj.sus_fl.init;
            sus_fr.init = obj.sus_fr.init;
            sus_rl.init = obj.sus_rl.init;
            sus_rr.init = obj.sus_rr.init;
            sus_fl.setup = obj.sus_fl.setup;
            sus_fr.setup = obj.sus_fr.setup;
            sus_rl.setup = obj.sus_rl.setup;
            sus_rr.setup = obj.sus_rr.setup;
            sus_fl.unsMass = obj.sus_fl.unsMass;
            sus_fr.unsMass = obj.sus_fr.unsMass;
            sus_rl.unsMass = obj.sus_rl.unsMass;
            sus_rr.unsMass = obj.sus_rr.unsMass;
            
            parfor i=1:numel(q)              
                % We could have easily done diff(Epot, q). But here we are not considering S as q dependent
                % so we must make the calculations by hand
                Epot_dq{i} = vpa(  -sus_fl.unsMass * grav' * (e_T_v_dq{i} * v_fl_cWH  + e_T_v * v_fl_cWH_dq(:,i) + e_pos_dq{i}) + ...
                                   -sus_fr.unsMass * grav' * (e_T_v_dq{i} * v_fr_cWH  + e_T_v * v_fr_cWH_dq(:,i) + e_pos_dq{i}) + ...
                                   -sus_rl.unsMass * grav' * (e_T_v_dq{i} * v_rl_cWH  + e_T_v * v_rl_cWH_dq(:,i) + e_pos_dq{i}) + ...
                                   -sus_rr.unsMass * grav' * (e_T_v_dq{i} * v_rr_cWH  + e_T_v * v_rr_cWH_dq(:,i) + e_pos_dq{i}) + ...
                                   -DNA.susMass    * grav' * (e_T_v_dq{i} * DNA.CG_s                         + e_pos_dq{i}) ); %#ok<*PFOUS> % + ...
%                                    sus_fl.setup.kspring   * (v_fl_bDS - norm(sus_fl.init.RKDS_0-sus_fl.init.DSCH_0)) * v_fl_bDS_dq(:,i) + ...
%                                    sus_fr.setup.kspring   * (v_fr_bDS - norm(sus_fr.init.RKDS_0-sus_fr.init.DSCH_0)) * v_fr_bDS_dq(:,i) + ...
%                                    sus_rl.setup.kspring   * (v_rl_bDS - norm(sus_rl.init.RKDS_0-sus_rl.init.DSCH_0)) * v_rl_bDS_dq(:,i) + ...
%                                    sus_rr.setup.kspring   * (v_rr_bDS - norm(sus_rr.init.RKDS_0-sus_rr.init.DSCH_0)) * v_rr_bDS_dq(:,i) ...
                                   

                e_fl_cWHp_dq{i} = e_posp_dq{i} + e_T_v_dq{i} * ( v_fl_cWH_dq     * qp + cross(v_angp,v_fl_cWH) ) ...
                                               + e_T_v       * ( v_fl_cWH_ddq{i} * qp + cross(v_angp_dq{i},v_fl_cWH) + cross(v_angp,v_fl_cWH_dq(:,i))   );
                e_fr_cWHp_dq{i} = e_posp_dq{i} + e_T_v_dq{i} * ( v_fr_cWH_dq     * qp + cross(v_angp,v_fr_cWH) ) ...
                                               + e_T_v       * ( v_fr_cWH_ddq{i} * qp + cross(v_angp_dq{i},v_fr_cWH) + cross(v_angp,v_fr_cWH_dq(:,i))   );
                e_rl_cWHp_dq{i} = e_posp_dq{i} + e_T_v_dq{i} * ( v_rl_cWH_dq     * qp + cross(v_angp,v_rl_cWH) ) ...
                                               + e_T_v       * ( v_rl_cWH_ddq{i} * qp + cross(v_angp_dq{i},v_rl_cWH) + cross(v_angp,v_rl_cWH_dq(:,i))   );
                e_rr_cWHp_dq{i} = e_posp_dq{i} + e_T_v_dq{i} * ( v_rr_cWH_dq     * qp + cross(v_angp,v_rr_cWH) ) ...
                                               + e_T_v       * ( v_rr_cWH_ddq{i} * qp + cross(v_angp_dq{i},v_rr_cWH) + cross(v_angp,v_rr_cWH_dq(:,i))   );
                e_CGp_dq{i}     = e_posp_dq{i} + e_T_v_dq{i} * (                        cross(v_angp,DNA.CG_s)         ) ...
                                               + e_T_v       * (                        cross(v_angp_dq{i},DNA.CG_s)   );

                Ekin_dq{i} = 0.5 * e_fl_cWHp_dq{i}.'  * sus_fl.unsMass * e_fl_cWHp  + 0.5 * e_fl_cWHp.' * sus_fl.unsMass * e_fl_cWHp_dq{i}  + ...
                             0.5 * e_fr_cWHp_dq{i}.'  * sus_fr.unsMass * e_fr_cWHp  + 0.5 * e_fr_cWHp.' * sus_fr.unsMass * e_fr_cWHp_dq{i}  + ...
                             0.5 * e_rl_cWHp_dq{i}.'  * sus_rl.unsMass * e_rl_cWHp  + 0.5 * e_rl_cWHp.' * sus_rl.unsMass * e_rl_cWHp_dq{i}  + ...
                             0.5 * e_rr_cWHp_dq{i}.'  * sus_rr.unsMass * e_rr_cWHp  + 0.5 * e_rr_cWHp.' * sus_rr.unsMass * e_rr_cWHp_dq{i}  + ...
                             0.5 * e_CGp_dq{i}.'      * DNA.susMass * e_CGp      + 0.5 * e_CGp.'     * DNA.susMass * e_CGp_dq{i}      + ...
                      diff2( 0.5 * v_angp.' * e_T_v.' * DNA.CG_I    * e_T_v * v_angp , q(i));


                e_fl_cWHp_dqp{i} = e_posp_dqp{i} + e_T_v * ( v_fl_cWH_dq(:,i) + cross(v_angp_dqp{i},v_fl_cWH) );
                e_fr_cWHp_dqp{i} = e_posp_dqp{i} + e_T_v * ( v_fr_cWH_dq(:,i) + cross(v_angp_dqp{i},v_fr_cWH) );
                e_rl_cWHp_dqp{i} = e_posp_dqp{i} + e_T_v * ( v_rl_cWH_dq(:,i) + cross(v_angp_dqp{i},v_rl_cWH) );
                e_rr_cWHp_dqp{i} = e_posp_dqp{i} + e_T_v * ( v_rr_cWH_dq(:,i) + cross(v_angp_dqp{i},v_rr_cWH) );    
                e_CGp_dqp{i}     = e_posp_dqp{i} + e_T_v * (                    cross(v_angp_dqp{i},DNA.CG_s) );

                e_fl_cWHp_dqp_p{i} =  e_T_v_p * ( v_fl_cWH_dq(:,i)   + cross(v_angp_dqp{i},v_fl_cWH) ) + ...
                                      e_T_v   * ( v_fl_cWH_dq_p(:,i) + cross(v_angp_dqp_p{i},v_fl_cWH) + cross(v_angp_dqp{i},v_fl_cWH_dq*qp) );
                e_fr_cWHp_dqp_p{i} =  e_T_v_p * ( v_fr_cWH_dq(:,i)   + cross(v_angp_dqp{i},v_fr_cWH) ) + ...
                                      e_T_v   * ( v_fr_cWH_dq_p(:,i) + cross(v_angp_dqp_p{i},v_fr_cWH) + cross(v_angp_dqp{i},v_fr_cWH_dq*qp) );
                e_rl_cWHp_dqp_p{i} =  e_T_v_p * ( v_rl_cWH_dq(:,i)   + cross(v_angp_dqp{i},v_rl_cWH) ) + ...
                                      e_T_v   * ( v_rl_cWH_dq_p(:,i) + cross(v_angp_dqp_p{i},v_rl_cWH) + cross(v_angp_dqp{i},v_rl_cWH_dq*qp) );
                e_rr_cWHp_dqp_p{i} =  e_T_v_p * ( v_rr_cWH_dq(:,i)   + cross(v_angp_dqp{i},v_rr_cWH) ) + ...
                                      e_T_v   * ( v_rr_cWH_dq_p(:,i) + cross(v_angp_dqp_p{i},v_rr_cWH) + cross(v_angp_dqp{i},v_rr_cWH_dq*qp) );
                e_CGp_dqp_p{i}     =  e_T_v_p * (                      cross(v_angp_dqp{i},DNA.CG_s) ) + ...
                                      e_T_v   * (                      cross(v_angp_dqp_p{i},DNA.CG_s)                                       );


                Ekin_dqp_dt{i} =  0.5 * DNA.susMass    * ( e_CGp_dqp_p{i}.' * e_CGp + e_CGp_dqp{i}.' * e_CGpp                   + ...
                                                              e_CGpp.' * e_CGp_dqp{i}  + e_CGp.' * e_CGp_dqp_p{i}               ) ; % + ...
%                                  0.5 * sus_fl.unsMass * ( e_fl_cWHp_dqp_p{i}.' * e_fl_cWHp + e_fl_cWHp_dqp{i}.' * e_fl_cWHpp   + ...
%                                                               e_fl_cWHpp.' * e_fl_cWHp_dqp{i}  + e_fl_cWHp.' * e_fl_cWHp_dqp_p{i}) + ...
%                                  0.5 * sus_fr.unsMass * ( e_fr_cWHp_dqp_p{i}.' * e_fr_cWHp + e_fr_cWHp_dqp{i}.' * e_fr_cWHpp   + ...
%                                                               e_fr_cWHpp.' * e_fr_cWHp_dqp{i}  + e_fr_cWHp.' * e_fr_cWHp_dqp_p{i}) + ... 
%                                  0.5 * sus_rl.unsMass * ( e_rl_cWHp_dqp_p{i}.' * e_rl_cWHp + e_rl_cWHp_dqp{i}.' * e_rl_cWHpp   + ...
%                                                               e_rl_cWHpp.' * e_rl_cWHp_dqp{i}  + e_rl_cWHp.' * e_rl_cWHp_dqp_p{i}) + ... 
%                                  0.5 * sus_rr.unsMass * ( e_rr_cWHp_dqp_p{i}.' * e_rr_cWHp + e_rr_cWHp_dqp{i}.' * e_rr_cWHpp   + ...
%                                                               e_rr_cWHpp.' * e_rr_cWHp_dqp{i}  + e_rr_cWHp.' * e_rr_cWHp_dqp_p{i}) + ...
%                                  0.5 * ( e_angp_dqp_p{i}.' * DNA.CG_I * e_angp + e_angp_dqp{i}.' * DNA.CG_I * e_angpp      + ...
%                                          e_angpp.' * DNA.CG_I * e_angp_dqp{i}  + e_angp.' * DNA.CG_I * e_angp_dqp_p{i} )      ...
                                         

                % AINDA FALTA A FORCA DO AMORTECEDOR
                Qnc{i} =  (e_pos_dq{i}   +   e_T_v_dq{i} * v_fl_TYRO   +   e_T_v * v_fl_TYRO_dq(:,i)).' * e_fl_Ftyre + ...
                          (e_pos_dq{i}   +   e_T_v_dq{i} * v_fr_TYRO   +   e_T_v * v_fr_TYRO_dq(:,i)).' * e_fr_Ftyre + ...
                          (e_pos_dq{i}   +   e_T_v_dq{i} * v_rl_TYRO   +   e_T_v * v_rl_TYRO_dq(:,i)).' * e_rl_Ftyre + ...
                          (e_pos_dq{i}   +   e_T_v_dq{i} * v_rr_TYRO   +   e_T_v * v_rr_TYRO_dq(:,i)).' * e_rr_Ftyre ;

                % Epot_dqp_dt{i}=0  because Epot must not depend on velocities 
                Lagrange{i} = Ekin_dqp_dt{i} - Ekin_dq{i} + Epot_dq{i} - Qnc{i};

                parfor_progress(pwd);
            end
            parfor_progress(pwd,0);
    
            fprintf('    Grouping differential equations...\n');
            Lagrange_sym = [Lagrange{:}];
            Lagrange_sym = Lagrange_sym(t).';
                             
            
            
            fprintf('    Reducing differential order...\n');
            [Lagrange_red, q_red, Rel] = reduceDifferentialOrder(Lagrange_sym, q); %#ok<ASGLU>
            
            obj.q = q;
            obj.q_red = q_red;
                      
            extra_vars_dq = [v_fl_TYRO_dq; v_fl_cWH_dq; v_fl_bDS_dq;
                             v_fr_TYRO_dq; v_fr_cWH_dq; v_fr_bDS_dq;
                             v_rl_TYRO_dq; v_rl_cWH_dq; v_rl_bDS_dq;
                             v_rr_TYRO_dq; v_rr_cWH_dq; v_rr_bDS_dq];
            extra_vars = [  v_fl_TYRO; v_fl_cWH; v_fl_bDS;     
                            v_fr_TYRO; v_fr_cWH; v_fr_bDS;                         
                            v_rl_TYRO; v_rl_cWH; v_rl_bDS;                    
                            v_rr_TYRO; v_rr_cWH; v_rr_bDS];          
            inputs =[e_fl_Ftyre; e_fr_Ftyre; e_rl_Ftyre; e_rr_Ftyre];
                             
            extra_params = setdiff(symvar(Lagrange_red), [symvar(q_red) symvar(extra_vars) symvar(extra_vars_dq) symvar(inputs)]); % MUST BE EMPTY
            if ~isempty(extra_params)
                error('Unkown parameters in the ODE functions set... Aborting');
            end
            
            
            fprintf('    Calculating mass matrix...\n');
            [M_ode,F_ode] = massMatrixForm(Lagrange_red,q_red);
            M_ode_fun = odeFunction(M_ode, q_red, extra_vars, extra_vars_dq, inputs, 'File','classes/@veh/M_ode_fun.m', 'Optimize', false);
            F_ode_fun = odeFunction(F_ode, q_red, extra_vars, extra_vars_dq, inputs, 'File','classes/@veh/F_ode_fun.m', 'Optimize', false);
        
            
            s_strings = {'TYRO_1','TYRO_2','TYRO_3','cWH_1','cWH_2','cWH_3','bDS'}';   
            extra_vars_k = @(q_red) [obj.sus_fl.getKinq([q_red(7);q_red(11)], s_strings);
                                     obj.sus_fr.getKinq([q_red(8);q_red(11)], s_strings);
                                     obj.sus_rl.getKinq([q_red(9);q_red(12)], s_strings);
                                     obj.sus_rr.getKinq([q_red(10);q_red(12)],s_strings)];           
            
            s_strings_all = cellfun(@char, sym2cell(obj.sus_fl.s),'UniformOutput', false);
            s_fl_k = @(q_red) obj.sus_fl.getKinq([q_red(7);q_red(11)], s_strings_all);
            s_fr_k = @(q_red) obj.sus_fr.getKinq([q_red(8);q_red(11)], s_strings_all);
            s_rl_k = @(q_red) obj.sus_rl.getKinq([q_red(9);q_red(12)], s_strings_all);
            s_rr_k = @(q_red) obj.sus_rr.getKinq([q_red(10);q_red(12)], s_strings_all);

            extra_vars_dq_k = @(q_red) [obj.sus_fl.get_K_matrices([q_red(7);q_red(11)],  s_fl_k(q_red), s_strings);
                                        obj.sus_fr.get_K_matrices([q_red(8);q_red(11)],  s_fr_k(q_red), s_strings);
                                        obj.sus_rl.get_K_matrices([q_red(9);q_red(12)],  s_rl_k(q_red), s_strings);
                                        obj.sus_rr.get_K_matrices([q_red(10);q_red(12)], s_rr_k(q_red), s_strings)];

            inputs_k = @(q_red) zeros([12,1]);

            M_ode_fun_k = @(t,q_red) obj.M_ode_fun(q_red, extra_vars_k(q_red), extra_vars_dq_k(q_red), inputs_k(q_red));
            F_ode_fun_k = @(t,q_red) obj.F_ode_fun(q_red, extra_vars_k(q_red), extra_vars_dq_k(q_red), inputs_k(q_red));
            

                M_ode_fun_k(1,[q_k; dq_k])
                F_ode_fun_k(1,[q_k; dq_k])
            
            opt = odeset('Mass', M_ode_fun_k, 'RelTol', 1e-3, 'AbsTol' ,1e-5, ...
                         'OutputFcn','odeplot'); %'MassSingular','no'
            q_k = [0 0 0   2 2 2  obj.sus_fl.init.LAUR_0(3) obj.sus_fr.init.LAUR_0(3) obj.sus_rl.init.LAUR_0(3) obj.sus_rr.init.LAUR_0(3)  0 0 ]';
            dq_k= [0 0 0      0 0 0      0 0 0 0     0 0]';
            tspan = [0,1];
            [tSol,ySol] = ode23t(F_ode_fun_k, tspan, [q_k; dq_k], opt);

            figure
            plot(tSol,ySol(:,4),'-o')
        end

    end   
end

