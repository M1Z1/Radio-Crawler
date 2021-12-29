(
"modules2.scd".loadRelative;
"pieces.scd".loadRelative;
o.value;
p.value;
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
			~pieces[~playindex].play;
				~pr = ~playindex;
	});
		~minduridx = ~playindex * 2;
		~maxduridx = ~minduridx + 1;
	rrand(~durations[~minduridx], ~durations[~maxduridx]).wait;
}).loop;
});


//////
~mute.value;
~showplayer.stop;
~show.value(~exampleshow1);
~showplayer.play;
);
