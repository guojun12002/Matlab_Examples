%---------NAR------------%
% Date : 20/01/2012
% Bilkent University
% Analysis of Rankine Cycle with MATLAB
% Authors: Ceren Yýldýz & Gökberk Kabacaoglu
% Advisor : Asst. Prof. Dr. Barbaros Cetin

In order to use program efficiently, you must be careful about following:

1) If you want to make analysis of REVERSIBLE Rankine Cycle, you have to enter your inputs in 'inputRevers.txt' and
you have to change 21st line of NAR.For instance;
Originally;

% GETTING INPUT
% Read Data from .txt
fid = fopen('inputIrrevers.txt');

and you want to calculate Reversible one, then your new line is;

% GETTING INPUT
% Read Data from .txt
fid = fopen('inputRevers.txt');

2) Same procedure must be applied for irreversible and reheated Rankine Cycle. For IRREVERSIBLE Rankine Cycle you must 
use 'inputIrrevers.txt' file and you have to change 21st line with 'inputIrrevers.txt'.

3)Similarly for REHEATED Rankine Cycle, input file is 'inputReheat.txt' and 21st line must be changed with 'inputReheat.txt'.

Have a nice Calculations!!=)