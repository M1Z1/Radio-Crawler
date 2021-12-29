(
o.value;
p =({
	~exampleshow1 = [[
		~morningmorsecodes = Pspawner({ |sp|
		w = sp;
		~tunerMasterParams.value([\rand,[5,20,1],\randlist,\free,[10135.82,10135.0,10135.20,10136.82,10134.82,10099.14,10099.00,10107.40, 10109.46,10080.92, 9994.58, 			9808.54, 9648.14, 9592.08, 9398.08, 9411.65, 9411.0, 9392.80, 9328.51, 9344.0, 9344.31, 9222.50],["LSB", "USB"]]);
		~lfoMasterParams.value([[5, 10, 1, 8, 3, 7],0,\lin]);
	w.par(~tuner1);
	w.par(~lfo1);
		~lfoMasterParams.value([[5, 10, 1, 8, 3, 7],0,\lin]);
	w.wait(7);
	w.par(~tuner2);
	w.par(~lfo2);
	w.wait(3);
	w.par(~tuner3);
	w.par(~lfo3);
	w.wait(6);
	w.par(~tuner4);
	w.par(~lfo4);
	}).play;,
		20,30

	],

[
~morningad = Pspawner({ |sp|
		w = sp;
		~envADMasterParams.value([\rand,\long, [0.2,2.0,0.1],[2.0,4.0, 0.1],0.5,0,0]);
	~tunerMasterParams.value([\silentlatch,\randlist, \free,[232.76,199.11,252.06,17649.89,17571.13,17878.59,17488.37,16248.33, 16098.83,15218.96,                    6148.41, 6068.32, 6084.11, 6213.14, 6003.24, 5914.81, 5848.96, 198.44,230.92, 647.39, 692.55, 819.13],["AM"]]);
	w.par(~envAD1);
	w.par(~envAD2);
	w.par(~envAD3);
	w.par(~envAD4);
sp.wait(1);
	w.par(~tuner1);
	w.par(~tuner2);
	w.par(~tuner3);
	w.par(~tuner4);
}).play;,
		30,40

	],
[
		~islReykjavik = Pspawner({ |sp|
		loop {
				w = sp;
			"thisIsALoop".postln;
			~envADMasterParams.value([\const,\long,5,1,-40,0]);
			~envAD1Params.value([\const,\long,2,0,-10,0]);
			~tuner1Params.value([\const, 15, \randlist, \sticky,[11184.00, "USB",7215.71,"USB", 7299.75, "USB"]]);
			w.par(~tuner1);
			w.par(~envAD1);w.par(~envAD2);w.par(~envAD3);w.par(~envAD4);
			w.wait(25);
				~lfo2Params.value([[5,15,3,8,10,20],-5,\lin]);
			~tuner2Params.value([\silentlatch,\randlist,\sticky, [7046.41, "USB", 7074.83, "USB", 7203.08,"usb"]]);
			w.par(~lfo2);
			w.par(~tuner2);
					w.wait(15);
					w.suspend(~tuner1);
			~envAD1Params.value([\const,\long,2,1,0,0]);
					w.wait(10);
		}}),
			120, 180
	],

	[


~morningadsolo = Pspawner({ |sp|
		w = sp;
	~envADMonoParams.value([\rand,\long,[0.2, 0.3,0.01],[0.05, 0.1,0.01], 0.3, 0,0]);
	~tunerMonoParams.value([\silentlatch,\randlist, \free,[232.76,199.11,252.06,17649.89,17571.13,17878.59,17488.37,16248.33, 16098.83,15218.96, 6148.41, 6068.32, 6084.11, 6213.14, 6003.24, 5914.81, 5848.96, 198.44,230.92, 647.39, 692.55, 819.13],["AM"]]);
	w.par(~envADMono);
	w.wait(1);
	w.par(~tunerMono);
		});,
		20,40
	]
	];
	~exampleshow2 = [[
		~radioscanner = Pspawner({ |sp|
			w =sp;
			~envAD1Params.value([\const,\long,0.1,0.01,-5,0]);
			~envAD2Params.value([\const,\long,60,1,-5,0]);
			~envAD3Params.value([\const,\long,60,1,-5,0]);
			~envAD4Params.value([\const,\long,60,1,-5,0]);
			~tuner1Params.value([\rand,[0.01,0.3,0.01], \scanner, \free,[10,1650,10],[20,60,1,1,40,120, \lin], [\AM]]);
				w.par(~tuner1);
	w.par(~envAD1);
	w.par(~envAD2);
	w.par(~envAD3);
	w.par(~envAD4);
	}).play;,
		40, 60
	],
	[

		~loopnoise = Pspawner({ |sp|
			w =sp;
			~envAD1Params.value([\const,\long,0.1,0.0,0,0]);
			~envAD2Params.value([\const,\long,60,1,-5,0]);
			~envAD3Params.value([\const,\long,60,1,-5,0]);
			~envAD4Params.value([\const,\long,60,1,-5,0]);
			~tuner1Params.value([\const,7, \shuffle, \sticky,[4467.48,\LSB,4769.98,\USB,13558.83,\USB,5829.61, \AM],4]);
			~tuner1Params.value([\const,2, \shuffle, \free,[4467.48,4769.98],2,["AM","FM"]]);
		~tuner1Pat.play;
			w.par(~tuner1);
			w.par(~envAD1);
		}),
		20, 40

	],
	[

		~loop1 = Pspawner ({ |sp|
			w = sp;
			~tuner1Params.value([\drunk,[0.2,2,0.1],\loop,\sticky,[7260.76, \AM, 7432.95, \AM, 7230.36, \AM, 61.29, \USB, 233.43, \AM, 242.49, \USB]]);
				~tuner2Params.value([\silentlatch,1,\randlist,\sticky,[298.55, \USB,297.27,\USB,288.21,\USB, 268.41, \USB]]);
				~envAD1Params.value([\drunk,\short,[0.2,3,0.1],0.01,0,0]);
				~lfo2Params.value([[10,30,1,1,10,15],0,\lin]);
			w.par(~tuner1);
			w.par(~envAD1);
			20.wait;
			w.par(~tuner2);
			w.par(~lfo2);
			90.wait;
			~tuner1Params.value([\drunk,[0.2,2,0.1],\loop,\sticky,[6365.34, \USB, 7432.95, \AM, 6192.07, \AM, 61.29, \USB, 233.43, \AM, 242.49, \USB]]);
		}).loop.play;
		20,40]



	];
~loopnoise.play;
	~loopnoise.stop; ~loopnoise.reset;
~loopnoise.stop; ~loopnoise.reset;
~radioscanner.stop; ~radioscanner.reset;
	~loop1.stop; ~loop1.reset;
	~morningad.stop; ~morningad.reset;
~morningadsolo.stop; ~morningadsolo.reset;
	~morningmorsecodes.stop; ~morningmorsecodes.reset;

});
);
