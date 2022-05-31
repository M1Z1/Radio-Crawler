(
"modules.scd".loadRelative;
"pieces.scd".loadRelative;

o.value;
p.value;
~lastindex = -1;
~show = ({ arg a;
a = a.flat;
	a.postln;
~durations=Array.new(5);
	~pieces.size;
~pieces=Array.new(5);
a.do{arg item, i; if (item.isInteger, {~durations = ~durations.add(item)},{~pieces = ~pieces.add(item); item.stop; item.reset;});};
~pr = -1;
~indexes = Array.series(~pieces.size,0,1);
~showplayer = Routine ({
if( ~indexes.size !== 0,
		{ ~playindex = ~indexes.removeAt(~indexes.size.rand);
			~pieces[~pr].stop;
			~pieces[~pr].reset;
				('stop' ++ ~pr).postln;
			~pieces[~playindex].play;
				('playone' ++ ~playindex).postln;
			~pr = ~playindex;
		},
		{~lastindex = ~playindex;
			~indexes = Array.series(~pieces.size,0,1);
			~indexes.removeAt(~lastindex);
			~playindex = ~indexes.removeAt(~indexes.size.rand);
			~indexes = ~indexes.add(~lastindex);
			~pieces[~lastindex].stop;
			~pieces[~lastindex].reset;
				('stop' ++ ~lastindex).postln;
			~pieces[~playindex].play;
				~pr = ~playindex;
				('playtwo' ++ ~playindex).postln;
	});
		~minduridx = ~playindex * 2;
		~maxduridx = ~minduridx + 1;
	rrand(~durations[~minduridx], ~durations[~maxduridx]).wait;
}).loop;
});
~pspawnerInit.play;
~limiter.value(-20);
);
);

~mute.value;
~showplayer.stop;~showplayer.reset;
~show.value(~exampleshow1);
~showplayer.play;
