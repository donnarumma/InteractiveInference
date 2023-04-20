function [params, seeds]=initializeParams(description,test_name,iRepetition,params)
% function params=initializeParams(description,test_name,iRepetition,params)

params.description                      = description;
params.test_name                        = test_name;
params.iRepetition                      = iRepetition;

params.res_dir                          = [params.default_dir '/results_djoint/'];
params.test_dir                         = [params.default_dir '/tests_djoint/'];
params.movie_dir                        = [params.default_dir '/movie/'];
params.tests_source_directory           = [params.test_dir '/' params.test_name '/'];
params.results_directory                = [params.res_dir  '/' params.test_name '/'];
params.save_dir                         = [params.results_directory '/' params.description '/'];
params.step_dir                         = [params.movie_dir '/' params.description '/'];
params.main_dir                         = [params.tests_source_directory '/MAINS/' ];
%%
nfold                                   = [params.tests_source_directory '/' params.description '/'];

if ~isfolder(params.tests_source_directory)
    mkdir(params.tests_source_directory);
end
if ~isfolder(params.save_dir)
    mkdir(params.save_dir)
end
if ~isfolder(params.results_directory)
    mkdir(params.results_directory);
end
if ~isfolder(params.step_dir)
    mkdir(params.step_dir);
end
if ~isfolder(params.main_dir)
    mkdir(params.main_dir)
end
if ~isfolder(nfold) 
	mkdir(nfold)
end

rng('default');seeds=getSeeds(10000);   %% seeds for rng  - same sequence for each case   

seed=seeds(params.iRepetition); rng(seed);              %% seed depends on the number of the repetition

if params.do_update_seed
    % seeds sequence depdend on repetion
    seeds=seeds(randperm(length(seeds)));
end