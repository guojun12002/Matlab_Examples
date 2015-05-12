%% Rab_filter
% Copywrite 2005-2010 The MathWorks, Inc.
% a bandpass structure from RLC elements
%% first cascade element
R = 1e-3;
R1 = rfckt.shuntrlc('R', R);
L1 = rfckt.shuntrlc('L', 0.258e-9);
R1serL1 = rfckt.series('Ckts', {R1, L1});

%% second cascade element
C1 = rfckt.shuntrlc('C', 68.182e-12);

%% third
L2 = rfckt.seriesrlc('L', 1.1866e-9);
C2 = rfckt.seriesrlc('C', 12.2946e-12);
L2parC2 = rfckt.parallel('Ckts', {L2,C2});

%% fourth
L3 = rfckt.seriesrlc('L', 1.4332e-9);
C3 = rfckt.seriesrlc('C', 14.8495e-12);
L3parC3 = rfckt.parallel('Ckts', {L3,C3});

%% fifth
R2 = rfckt.shuntrlc('R', R);
L4 = rfckt.shuntrlc('L', 0.2104e-9);
R2serL4 = rfckt.series('Ckts', {R2, L4});

%% sixth
C4 = rfckt.shuntrlc('C', 83.7473e-12);

%% seventh
L5 = rfckt.seriesrlc('L', 0.4442e-9);
C5 = rfckt.seriesrlc('C', 34.9468e-12);
L5parC5 = rfckt.parallel('Ckts', {L5,C5});

%% eight
L6 = rfckt.seriesrlc('L', 0.5042e-9);
C6 = rfckt.seriesrlc('C', 39.6714e-12);
L6parC6 = rfckt.parallel('Ckts', {L6,C6});

%% ninth
R3 = rfckt.shuntrlc('R', R);
L7 = rfckt.shuntrlc('L', 0.2983e-9);
R3serL7 = rfckt.series('Ckts', {R3, L7});

%% tenth
C7 = rfckt.shuntrlc('C', 59.0783e-12);

%% cascade all ten
LCBPF_filt = rfckt.cascade('Ckts',{R1serL1, C1, L2parC2, L3parC3, R2serL4, C4,...
    L5parC5, L6parC6, R3serL7, C7});

LCBPF_filt.analyze(1.1e9:1e6:1.3e9);

% hd = getdata(filt);
% filt.plot('S21')

