(
"modules2.scd".loadRelative;
"pieces.scd".loadRelative;
o.value;
p.value;
		~islReykjavik.play;
~show = ({ arg a;
a = a.flat;
~durations=Array.new(5);
~pieces=Array.new(5);
a.do{arg item, i; if (item.isInteger, {~durations = ~durations.add(item)},{~pieces = ~pieces.add(item)});};
~pr = -1;
~indexes = Array.series(~pieces.size,0,1);
~showplayer = Routine ({
if( ~indexes.size !== 0,
		{ ~playindex = ~indexes.removeAt(~indexes.size.rand);
			~pieces[~pr].stop;
			~pieces[~pr].reset;
			("stopelse" ++ ~pr).postln;
			~pieces[~playindex].play;
		     ~playindex.postln;
			~pr = ~playindex;
		},
		{~lastindex = ~playindex;
			~indexes = Array.series(~pieces.size,0,1);
			~indexes.removeAt(~lastindex);
			~playindex = ~indexes.removeAt(~indexes.size.rand);
			~indexes = ~indexes.add(~lastindex);
			~pieces[~lastindex].stop;
			~pieces[~lastindex].reset;
			("stopif" ++ ~lastindex).postln;
			~pieces[~playindex].play;
				~pr = ~playindex;
				~playindex.postln;
	});
		~minduridx = ~playindex * 2;
		~maxduridx = ~minduridx + 1;
	rrand(~durations[~minduridx], ~durations[~maxduridx]).postln.wait;
}).loop;
});

~show.value(~exampleshow1);
~showplayer.play;
);
~showplayer.stop;

~mute.value;

/////////////////////////////////////////////////////////

~envAD3Params.value([\rand, \long, [1,3,0.2], [1, 1, 0.5],0.5,-6,0])


 ~tuner1Params.value([\const, 2, \randlist, \sticky,[4467.48,"AM",4769.98,"FM",367.9,"USB",400, "USB"]]);

~tunerMasterParams.value([\acc, [0.5,5,0.1], \randlist, \sticky, [710,\AM,19.24, \USB, 38.99, \LSB, 77.58, \AMsync ]])

~tuner3Pat.play;
~envAD3Pat.play;

~tuner3Params.value([\silentlatch, \loop, \sticky,[100, \AM, 200, \FM, 300, \CW]]);

~tunerMonoParams.value([\drunk, [1,3,0.2], \randlist, \free, [710, 19.24, 38.99, 77.58],[\AM, \USB, \LSB, \AMsync]])

~morningadsolo.play;
~morningadsolo.reset; ~morningadsolo.stop;
~morningad.play;