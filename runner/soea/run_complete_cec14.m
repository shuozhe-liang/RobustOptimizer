function run_complete_cec14(solvers, NP, Q, R)
if matlabpool('size') == 0
	matlabpool('open');
end

load('initialX.mat');
measureOptions.Dimension = 30;
measureOptions.Runs = 28;
measureOptions.MaxFunEvals = measureOptions.Dimension * 1e4;
measureOptions.LowerBounds = -100;
measureOptions.UpperBounds = 100;
measureOptions.FitnessFunctions = ...
	{'cec14_f1', 'cec14_f2', 'cec14_f3', 'cec14_f4', ...
	'cec14_f5', 'cec14_f6', 'cec14_f7', 'cec14_f8', 'cec14_f9', ...
	'cec14_f10', 'cec14_f11', 'cec14_f12', 'cec14_f13', ...
	'cec14_f14', 'cec14_f15', 'cec14_f16', 'cec14_f17', ...
	'cec14_f18', 'cec14_f19', 'cec14_f20', 'cec14_f21', ...
	'cec14_f22', 'cec14_f23', 'cec14_f24', 'cec14_f25', ...
	'cec14_f26', 'cec14_f27', 'cec14_f28', 'cec14_f29', ...
	'cec14_f30'};
solverOptions.dimensionFactor = NP / measureOptions.Dimension;
solverOptions.NP = NP;
solverOptions.F = 0.7;
solverOptions.CR = 0.5;
solverOptions.RecordPoint = 21;
solverOptions.ftarget = 1e-8;
solverOptions.TolX = 0;
solverOptions.TolStagnationIteration = Inf;
solverOptions.initial.X = eval(sprintf('XD%dNP%d', ...
	measureOptions.Dimension, ...
	solverOptions.NP));

filenames = cell(numel(Q), numel(solvers));
outsidedate = datestr(now, 'yyyymmddHHMM');
metafilename = sprintf('filenames_%s.mat', outsidedate);
for isolver = 1 : numel(solvers)
	for iQ = 1 : numel(Q)
		startTime = tic;
		innerdate = datestr(now, 'yyyymmddHHMM');
		solver = solvers{isolver};
		solverOptions.Q = Q(iQ);
		solverOptions.R = R;
		[allout, allfvals, allfes, T0, T1, T2] = complete_cec14(...
			solver, ...
			measureOptions, ...
			solverOptions); %#ok<NASGU,ASGLU>
		
		elapsedTime = toc(startTime);
		if elapsedTime < 60
			fprintf('Elapsed time is %f seconds\n', elapsedTime);
		elseif elapsedTime < 60*60
			fprintf('Elapsed time is %f minutes\n', elapsedTime/60);
		elseif elapsedTime < 60*60*24
			fprintf('Elapsed time is %f hours\n', elapsedTime/60/60);
		else
			fprintf('Elapsed time is %f days\n', elapsedTime/60/60/24);
		end
		
		filenames{iQ, isolver} = sprintf('cec14D%d_%s_Q%d_%s.mat', ...
			measureOptions.Dimension, solver, solverOptions.Q, innerdate);
		save(filenames{iQ, isolver}, ...
			'allout', ...
			'allfvals', ...
			'allfes', ...
			'T0', 'T1', 'T2', ...
			'solver', ...
			'measureOptions', ...
			'solverOptions', ...
			'elapsedTime');
	end
	
	save(metafilename, 'filenames');
end
end