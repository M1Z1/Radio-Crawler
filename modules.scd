(
o = ({
~targetAddress = NetAddr("127.0.0.1", 57121);
~baseMessage = "/fromSC";
~oscTransmitter =
	Pfunc({|ev|
		var oscArray = [~baseMessage];

		// Construct the osc array from the Pbind's keys
		ev.keysValuesDo{|k,v|
			// Filter out the 'destination' and 'id' keys
			(k != 'destination' and: {k != 'id'}).if{
				oscArray = oscArray ++ k ++ [v];
			}
		}.postln;
		// And send
		ev.destination.sendBundle(~latency, oscArray)
	});
~arrayRange =({arg start=0, end=9, step=1;
		Array.series(((end-start)/step)+ 1,start,step);
	});
~limiter = ({ arg a = -18;
		Pbindef(\limit,
		\limiter, Pn(a,1),
		\destination, ~targetAddress,
		\id, 'limiter',
		\play, ~oscTransmitter).play;
	});
//ON DUR RAND RANGE//OFF DUR RAND RANGE//REST PROBABILITY//RATE MODE//SUSTAIN VOLUME//SOLO
~envAD1Params = ({arg a;
		~envAD1Val = a;
		~envAD1Set.value;});
~envAD2Params = ({arg a;
		~envAD2Val = a;
		~envAD2Set.value;});
~envAD3Params = ({arg a;
		~envAD3Val = a;
		~envAD3Set.value;});
~envAD4Params = ({arg a;
		~envAD4Val = a;
		~envAD4Set.value;});
~envADMonoParams = ({arg a;
		~envADMonoVal = a;
		~envADMonoSet.value;});
~envADMasterParams = ({arg b=[\rand,\long,[2,3,0.5],[3,4,0.5],0.5,0,0];
		~envAD1Params.value(b);
		~envAD2Params.value(b);
		~envAD3Params.value(b);
		~envAD4Params.value(b);
});
	//[RATE MODE,[ON RANGE],[OFF RANGE],[RATE], REST PROB,SHORT-LONG MODE, MASTER VOLUME, SOLO]//  opos einai--short--// on-off idios xronos// kai ola ta dur manipulations
	//

	~envADMasterParams.value([\const,\long,1,1,0,0]);
	// ~envAD2.play;
~envAD1Set=({
		var n; var z; var f; var y; var r; var m; var l; var d; var v; var t; var x;
		if(~envAD1Val[0] == \rand,{
		n = ~envAD1Val[2];
		z = ~arrayRange.value(n[0],n[1],n[2]);
		f = ~envAD1Val[3];
		y = ~arrayRange.value(f[0],f[1],f[2]);
		r = ~envAD1Val[4];
		m = ~envAD1Val[5];
		l = ~envAD1Val[6];
		d = 1;			},{
			z = [1];
			y = [1];
		v = ~envAD1Val[2];
		r = ~envAD1Val[3];
		m = ~envAD1Val[4];
		l = ~envAD1Val[5];
		d = 1;
		if (v.size > 1, {
		t =~arrayRange.value(v[0],v[1],v[2]);
		x = t.size-1;
			});
	});
			~envAD1Pat = Pbindef(\envelopeAD1,
			\restprob, Pfunc({r.coin.binaryValue}),
			\on, Prand(z,inf),
			\off, Prand(y,inf),
			\volume,Pswitch([Pseq([m,-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~ad1 = event;}),
			\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)),(Pkey(\off, inf))),
			\destination, ~targetAddress,
			\id, 'envelopeAD1',
			\voice, 0,
			\solo, l,
			\timingOffset, 0.01,
			\play, ~oscTransmitter
		);
		switch (~envAD1Val[1],
			\long, { Pbindef(\envelopeAD1,\volume,Pswitch([m, -80],Pkey(\restprob, inf), inf).collect({|event|~ad1 = event;})); d=1;},
			\short, {Pbindef(\envelopeAD1,\volume,Pswitch([Pseq([~envAD1Val[6],-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~ad1 = event;})); d=2;}
			);
				switch (~envAD1Val[0],
			\const, { Pbindef(\envelopeAD1,\dur,Pfunc({(v/d)}).collect({|event|~adDur1 = event;}))},
			\rand,  {Pbindef(\envelopeAD1,\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)/d),(Pkey(\off, inf)/d)).collect({|event|~adDur1 = event;}))},
			\drunk, {Pbindef(\envelopeAD1,\dur, Pwalk(t/d,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2).collect({|event|~adDur1 = event;}))},
			\dec, {Pbindef(\envelopeAD1,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([1, -1],inf),0).collect({|event|~adDur1 = event;}))},
			\acc, {Pbindef(\envelopeAD1,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([-1, 1], inf),x).collect({|event|~adDur1 = event;}))},
		);
	});

~envAD2Set=({
		var n; var z; var f; var y; var r; var m; var l; var d; var v; var t; var x;
		if(~envAD2Val[0] == \rand,{
		n = ~envAD2Val[2];
		z = ~arrayRange.value(n[0],n[1],n[2]);
		f = ~envAD2Val[3];
		y = ~arrayRange.value(f[0],f[1],f[2]);
		r = ~envAD2Val[4];
		m = ~envAD2Val[5];
		l = ~envAD2Val[6];
		d = 1;			},{
			z = [1];
			y = [1];
		v = ~envAD2Val[2];
		r = ~envAD2Val[3];
		m = ~envAD2Val[4];
		l = ~envAD2Val[5];
		d = 1;
		if (v.size > 1, {
		t =~arrayRange.value(v[0],v[1],v[2]);
		x = t.size-1;
			});
	});
			~envAD2Pat = Pbindef(\envelopeAD2,
			\restprob, Pfunc({r.coin.binaryValue}),
			\on, Prand(z,inf),
			\off, Prand(y,inf),
			\volume,Pswitch([Pseq([m,-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~ad2 = event;}),
			\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)),(Pkey(\off, inf))),
			\destination, ~targetAddress,
			\id, 'envelopeAD1',
			\voice, 1,
			\solo, l,
			\timingOffset, 0.01,
			\play, ~oscTransmitter
		);
		switch (~envAD2Val[1],
			\long, { Pbindef(\envelopeAD2,\volume,Pswitch([m, -80],Pkey(\restprob, inf), inf).collect({|event|~ad2 = event;})); d=1;},
			\short, {Pbindef(\envelopeAD2,\volume,Pswitch([Pseq([~envAD2Val[6],-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~ad2 = event;})); d=2;}
			);
				switch (~envAD2Val[0],
			\const, { Pbindef(\envelopeAD2,\dur,Pfunc({(v/d)}).collect({|event|~adDur2 = event;}))},
			\rand,  {Pbindef(\envelopeAD2,\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)/d),(Pkey(\off, inf)/d)).collect({|event|~adDur2 = event;}))},
			\drunk, {Pbindef(\envelopeAD2,\dur, Pwalk(t/d,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2).collect({|event|~adDur2 = event;}))},
			\dec, {Pbindef(\envelopeAD2,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([1, -1],inf),0).collect({|event|~adDur2 = event;}))},
			\acc, {Pbindef(\envelopeAD2,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([-1, 1], inf),x).collect({|event|~adDur2 = event;}))},
		);
			});
~envAD3Set=({
		var n; var z; var f; var y; var r; var m; var l; var d; var v; var t; var x;
		if(~envAD3Val[0] == \rand,{
		n = ~envAD3Val[2];
		z = ~arrayRange.value(n[0],n[1],n[2]);
		f = ~envAD3Val[3];
		y = ~arrayRange.value(f[0],f[1],f[2]);
		r = ~envAD3Val[4];
		m = ~envAD3Val[5];
		l = ~envAD3Val[6];
		d = 1;			},{
			z = [1];
			y = [1];
		v = ~envAD3Val[2];
		r = ~envAD3Val[3];
		m = ~envAD3Val[4];
		l = ~envAD3Val[5];
		d = 1;
		if (v.size > 1, {
		t =~arrayRange.value(v[0],v[1],v[2]);
		x = t.size-1;
			});
	});
			~envAD3Pat = Pbindef(\envelopeAD3,
			\restprob, Pfunc({r.coin.binaryValue}),
			\on, Prand(z,inf),
			\off, Prand(y,inf),
			\volume,Pswitch([Pseq([m,-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~ad3 = event;}),
			\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)),(Pkey(\off, inf))),
			\destination, ~targetAddress,
			\id, 'envelopeAD3',
			\voice, 2,
			\solo, l,
			\timingOffset, 0.01,
			\play, ~oscTransmitter
		);
		switch (~envAD3Val[1],
			\long, { Pbindef(\envelopeAD3,\volume,Pswitch([m, -80],Pkey(\restprob, inf), inf).collect({|event|~ad3 = event;})); d=1;},
			\short, {Pbindef(\envelopeAD3,\volume,Pswitch([Pseq([~envAD3Val[6],-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~ad3 = event;})); d=2;}
			);
				switch (~envAD3Val[0],
			\const, { Pbindef(\envelopeAD3,\dur,Pfunc({(v/d)}).collect({|event|~adDur3 = event;}))},
			\rand,  {Pbindef(\envelopeAD3,\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)/d),(Pkey(\off, inf)/d)).collect({|event|~adDur3 = event;}))},
			\drunk, {Pbindef(\envelopeAD3,\dur, Pwalk(t/d,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2).collect({|event|~adDur3 = event;}))},
			\dec, {Pbindef(\envelopeAD3,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([1, -1],inf),0).collect({|event|~adDur3 = event;}))},
			\acc, {Pbindef(\envelopeAD3,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([-1, 1], inf),x).collect({|event|~adDur3 = event;}))},
		);
	});
~envAD4Set=({
		var n; var z; var f; var y; var r; var m; var l; var d; var v; var t; var x;
		if(~envAD4Val[0] == \rand,{
		n = ~envAD4Val[2];
		z = ~arrayRange.value(n[0],n[1],n[2]);
		f = ~envAD4Val[3];
		y = ~arrayRange.value(f[0],f[1],f[2]);
		r = ~envAD4Val[4];
		m = ~envAD4Val[5];
		l = ~envAD4Val[6];
		d = 1;			},{
			z = [1];
			y = [1];
		v = ~envAD4Val[2];
		r = ~envAD4Val[3];
		m = ~envAD4Val[4];
		l = ~envAD4Val[5];
		d = 1;
		if (v.size > 1, {
		t =~arrayRange.value(v[0],v[1],v[2]);
		x = t.size-1;
			});
	});
			~envAD4Pat = Pbindef(\envelopeAD4,
			\restprob, Pfunc({r.coin.binaryValue}),
			\on, Prand(z,inf),
			\off, Prand(y,inf),
			\volume,Pswitch([Pseq([m,-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~ad4 = event;}),
			\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)),(Pkey(\off, inf))),
			\destination, ~targetAddress,
			\id, 'envelopeAD4',
			\voice, 3,
			\solo, l,
			\timingOffset, 0.01,
			\play, ~oscTransmitter
		);
		switch (~envAD4Val[1],
			\long, { Pbindef(\envelopeAD4,\volume,Pswitch([m, -80],Pkey(\restprob, inf), inf).collect({|event|~ad4 = event;})); d=1;},
			\short, {Pbindef(\envelopeAD4,\volume,Pswitch([Pseq([~envAD4Val[6],-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~ad4 = event;})); d=2;}
			);
				switch (~envAD4Val[0],
			\const, { Pbindef(\envelopeAD4,\dur,Pfunc({(v/d)}).collect({|event|~adDur4 = event;}))},
			\rand,  {Pbindef(\envelopeAD4,\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)/d),(Pkey(\off, inf)/d)).collect({|event|~adDur4 = event;}))},
			\drunk, {Pbindef(\envelopeAD4,\dur, Pwalk(t/d,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2).collect({|event|~adDur4 = event;}))},
			\dec, {Pbindef(\envelopeAD4,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([1, -1],inf),0).collect({|event|~adDur4 = event;}))},
			\acc, {Pbindef(\envelopeAD4,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([-1, 1], inf),x).collect({|event|~adDur4 = event;}))},
		);
	});
~envADMonoSet=({
		var n; var z; var f; var y; var r; var m; var l; var d; var v; var t; var x;
		if(~envADMonoVal[0] == \rand,{
		n = ~envADMonoVal[2];
		z = ~arrayRange.value(n[0],n[1],n[2]);
		f = ~envADMonoVal[3];
		y = ~arrayRange.value(f[0],f[1],f[2]);
		r = ~envADMonoVal[4];
		m = ~envADMonoVal[5];
		d = 1;			},{
			z = [1];
			y = [1];
		v = ~envADMonoVal[2];
		r = ~envADMonoVal[3];
		m = ~envADMonoVal[4];
		d = 1;
		if (v.size > 1, {
		t =~arrayRange.value(v[0],v[1],v[2]);
		x = t.size-1;
			});
	});
			~envADMonoPat = Pbindef(\envelopeADMono,
			\restprob, Pfunc({r.coin.binaryValue}),
			\on, Prand(z,inf),
			\off, Prand(y,inf),
			\volume,Pswitch([Pseq([m,-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~adMono = event;}),
			\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)),(Pkey(\off, inf))),
			\destination, ~targetAddress,
			\id, 'envelopeADMono',
			\voice, Pseq([Pseries (0, 1, 4)], inf).collect({|event|~adMonoVoice = event;}),
			\solo, 1,
			\timingOffset, 0.01,
			\play, ~oscTransmitter
		);
		switch (~envADMonoVal[1],
			\long, {Pbindef(\envelopeADMono,\volume,Pswitch([m, -80],Pkey(\restprob, inf), inf).collect({|event|~adMono = event;})); d=1;},
			\short, {Pbindef(\envelopeADMono,\volume,Pswitch([Pseq([~envADMonoVal[6],-80],1), -80],Pkey(\restprob, inf), inf).collect({|event|~adMono = event;})); d=2;}
			);
				switch (~envADMonoVal[0],
			\const, {Pbindef(\envelopeADMono,\dur,v/d.collect({|event|~adDurMono = event;}))},
			\rand,  {Pbindef(\envelopeADMono,\dur, Pif(Pkey(\volume, inf)|==|m, (Pkey(\on, inf)/d),(Pkey(\off, inf)/d)).collect({|event|~adDurMono = event;}))},
			\drunk, {Pbindef(\envelopeADMono,\dur, Pwalk(t/d,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2).collect({|event|~adDurMono = event;}))},
			\dec, {Pbindef(\envelopeADMono,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([1, -1],inf),0).collect({|event|~adDurMono = event;}))},
			\acc, {Pbindef(\envelopeADMono,\dur,Pwalk(t/d,Pseq([1], inf),Pseq([-1, 1], inf),x).collect({|event|~adDurMono = event;}))},
		);
	});
	//[FREQUENCIES]//[MODES]//DUR RAND RANGE//SOLO
~tuner1Params = ({arg a;
		~tuner1Val = a;
		~tuner1Set.value;});
~tuner2Params = ({arg a;
		~tuner2Val = a;
		~tuner2Set.value;});
~tuner3Params = ({arg a;
		~tuner3Val = a;
		~tuner3Set.value;});
~tuner4Params = ({arg a;
		~tuner4Val = a;
		~tuner4Set.value;});
~tunerMonoParams = ({arg a;
		~tunerMonoVal = a;
		~tunerMonoSet.value;});
	~tunerMasterParams = ({arg b=[\const,1,\randrange,\sticky,[100,200],[\am]];
		if ( (b.find([\randrange])!==nil) ||(b.find([\scanner])!==nil),
			{
		~tuner1Params.value(b);
		~tuner2Params.value(b);
		~tuner3Params.value(b);
		~tuner4Params.value(b);
			},
			{
				if (b.find([\sticky]) == nil,
					{
						~fidx= (b.find([\free])+1);
						f=(b[~fidx]);
						~f1=[];~f2=[];~f3=[];~f4=[];
						f.do ({arg item, i; m = (i % 4);
							switch (m,
								0,{~f1 = ~f1.add(item)},
								1,{~f2 = ~f2.add(item)},
								2,{~f3 = ~f3.add(item)},
								3,{~f4 = ~f4.add(item)}
			)
				});
			~b1 = b.copy; ~b2 = b.copy; ~b3 = b.copy; ~b4 = b.copy;
			~b1 = ~b1.put(~fidx,~f1);
			~b2 = ~b2.put(~fidx,~f2);
			~b3 = ~b3.put(~fidx,~f3);
			~b4 = ~b4.put(~fidx,~f4);
		},
		{
			~fidx =(1 + b.find([\sticky]));
			f=(b[~fidx]);
			~f1=[];~f2=[];~f3=[];~f4=[];
			f.pairsDo({arg freq, mode, i;
			m = ((i/2)%4).asInteger;
				switch (m,
					0,{~f1 = ~f1.add(freq); ~f1 = ~f1.add(mode)},
					1,{~f2 = ~f2.add(freq); ~f2 = ~f2.add(mode)},
					2,{~f3 = ~f3.add(freq); ~f3 = ~f3.add(mode)},
					3,{~f4 = ~f4.add(freq); ~f4 = ~f4.add(mode)}
			)
				});

			~b1 = b.copy; ~b2 = b.copy; ~b3 = b.copy; ~b4 = b.copy;
			~b1 = ~b1.put(~fidx,~f1);
			~b2 = ~b2.put(~fidx,~f2);
			~b3 = ~b3.put(~fidx,~f3);
			~b4 = ~b4.put(~fidx,~f4);
		}
		);
		~tuner1Params.value(~b1);
		~tuner2Params.value(~b2);
		~tuner3Params.value(~b3);
		~tuner4Params.value(~b4);
		});
	});


	~tuner1Set=({

		var l; var times; var g; var t = [1]; var x; var d; var tempfreq; var tempmode; var loop; var freqshuf; var modeshuf;
		var randlist; var looparray; var freqloop; var modeloop; var freqrand; var moderand;
		var freq=[1,2];
		var a;
		var c;
		var b= 1;
		var mode= [\am,\fm];
		var v;
		if ((~tuner1Val[1].isNumber == false) && (~tuner1Val[1].isArray == false),
			{~tuner1Val = ~tuner1Val.insert(1,1)});

		v = ~tuner1Val[1];
		if (v.size > 1,
			{
				t =~arrayRange.value(v[0],v[1],v[2]);

				x = t.size-1;
		});


		a = ~tuner1Val[4];
		c = (a.size)/2;
		~tuner1Pat = Pbindef(\tuner1,
			\gate, 1,
			\stickyfunc, 1,
			\dur, 1,
			\mode,\am,
			\frequency, 100,
			\destination, ~targetAddress,
			\id, 'tuner1',
			\voice, 0,
			\play, ~oscTransmitter
		);
		switch (~tuner1Val[0],
			\silentlatch, {Pbindef(\tuner1,\dur,Pfunc({~adDur1}))},
			\latch, 	  {Pbindef(\tuner1,\dur,Pfunc({~adDur1}))},
			\const, 	  {Pbindef(\tuner1,\dur,v)},
			\rand,  	  {Pbindef(\tuner1,\dur, Prand(t,inf))},
			\drunk, 	  {Pbindef(\tuner1,\dur, Pwalk(t,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2))},
			\dec, 		  {Pbindef(\tuner1,\dur,Pwalk(t,Pseq([1], inf),Pseq([1, -1],inf),0))},
			\acc, 		  {Pbindef(\tuner1,\dur,Pwalk(t,Pseq([1], inf),Pseq([-1, 1], inf),x))},
		);
		if (~tuner1Val[0] !== \silentlatch,
			//if not silentlatch
			{
				if(~tuner1Val[3] == \free,{
					switch (~tuner1Val[2],
						\randrange, {Pbindef(\tuner1,\frequency, Pwhite(a[0],a[1],inf),
							\mode, Prand(~tuner1Val[5],inf)
						)},
						\scanner, { l = ~tuner1Val[5]; g = ~tuner1Val[5].size - 1;
							Pbindef(\tuner1, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),																          			  Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
								\mode, Prand(~tuner1Val[6], inf)
						)},
						\shuffle, { b = ~tuner1Val[5];
							Pbindef(\tuner1, \frequency, Pn(Pshuf(a,b),inf),
								\mode, Prand(~tuner1Val[6],inf)
						)},
						\randlist,  {Pbindef(\tuner1, \frequency, Prand(a, inf),
							\mode, Prand(~tuner1Val[5],inf)
						)},
						\loop, 		{Pbindef(\tuner1, \frequency, Pseq(a, inf),
							\mode, Prand(~tuner1Val[5],inf)
						)}
					)
				},
				{
					a = ~tuner1Val[4].clump(2);
					switch (~tuner1Val[2],
						\randrange, {a = a.flat;
							Pbindef(\tuner1,\frequency, Pwhite(a[0],a[1],inf),
								\mode, Prand(~tuner1Val[5], inf)
						)},
						\scanner, { a = a.flat; l = ~tuner1Val[5]; g = ~tuner1Val[5].size - 1;
							Pbindef(\tuner1, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),
								Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
							\mode, Prand(~tuner1Val[6], inf)
						)},
						\shuffle, {	b = ~tuner1Val[5]; times = b*c;
							Pbindef(\tuner1, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({
									d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq = tempfreq.add(d[loop][0]);
										tempmode = tempmode.add(d[loop][1]);});
									freqshuf = tempfreq; modeshuf = tempmode;
								}),inf,\step),
								\frequency, Pn(Plazy({Pseq(freqshuf,1)}),inf),
								\mode, Pn(Plazy({Pseq(modeshuf,1)}),inf)
						)},
						\randlist,{ Pbindef(\tuner1, \stickyfunc, Pn(Plazy({
							randlist = a.choose;
							freq=randlist[0];
							mode=randlist[1]
						}),inf),
						\frequency, Pn(Plazy({freq}),inf),
						\mode,Pn(Plazy({mode}),inf)
						)},
						\loop, { looparray =~tuner1Val[4];
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber,
									{tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq.postln; modeloop = tempmode.postln;
							Pbindef(\tuner1, \stickyfunc, 1,
								\frequency, Pn(Plazy({Pseq(freqloop,1)}),inf),
								\mode,  Pn(Plazy({Pseq(modeloop,1)}),inf)
						)}
					)
				})
			},
			{
				if ( ~tuner1Val[3] == \free,{
					switch (~tuner1Val[2],
						\randrange, {Pbindef(\tuner1,\frequency, Pif(Pfunc{~ad1} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequency1 }
						).collect { |freqs| ~lastFrequency1 = freqs },
						\mode, Pif(Pfunc{~ad1} < -39, Prand(~tuner1Val[5],inf),Pfunc { ~lastMode1 }
						).collect { |modes| ~lastMode1 = modes }
						)},
						\scanner, { l = ~tuner1Val[5]; g = ~tuner1Val[5].size - 1;
							Pbindef(\tuner1, \frequency,Pif(Pfunc{~ad1} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequency1}
							).collect { |freqs| ~lastFrequency1 = freqs },
							\mode, Pif(Pfunc{~ad1} < -39, Prand(~tuner1Val[6], inf),Pfunc { ~lastMode1 }
							).collect { |modes| ~lastMode1 = modes }
						)},
						\shuffle, { b =~tuner1Val[5];
							Pbindef(\tuner1, \frequency,Pif(Pfunc{~ad1} < -39, Pn(Pshuf(a,b),inf),Pfunc { ~lastFrequency1 }
							).collect { |freqs| ~lastFrequency1 = freqs },
							\mode, Pif(Pfunc{~ad1} < -39, Prand(~tuner1Val[6],inf),Pfunc { ~lastMode1 }
							).collect { |modes| ~lastMode1 = modes }
						)},
						\randlist, {Pbindef(\tuner1, \frequency, Pif(Pfunc{~ad1} < -39, Prand(a, inf),Pfunc { ~lastFrequency1 }
						).collect { |freqs| ~lastFrequency1 = freqs },
						\mode, Pif(Pfunc{~ad1} < -39, Prand(~tuner1Val[5],inf),Pfunc { ~lastMode1 }
						).collect { |modes| ~lastMode1 = modes }
						)},
						\loop, {Pbindef(\tuner1, \frequency, Pif(Pfunc{~ad1} < -39, Pseq(a, inf),Pfunc { ~lastFrequency1 }
						).collect { |freqs| ~lastFrequency1 = freqs },
						\mode, Pif(Pfunc{~ad1} < -39, Prand(~tuner1Val[5],inf),Pfunc { ~lastMode1 }
						).collect { |modes| ~lastMode1 = modes }
						)}
					)
				}
				,
				{
					a = ~tuner1Val[4].clump(2);
					switch (~tuner1Val[2],
						\randrange, {a = a.flat;
							Pbindef(\tuner1,\frequency, Pif(Pfunc{~ad1} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequency1 }
							).collect { |freqs| ~lastFrequency1 = freqs },
							\mode, Pif(Pfunc{~ad1} < -39, Prand(~tuner1Val[5],inf),Pfunc { ~lastMode1 }
							).collect { |modes| ~lastMode1 = modes }
						)},
						\scanner, {a = a.flat; l = ~tuner1Val[5]; g = ~tuner1Val[5].size - 1;
							Pbindef(\tuner1, \frequency,Pif(Pfunc{~ad1} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequency1}
							).collect { |freqs| ~lastFrequency1 = freqs },
							\mode, Pif(Pfunc{~ad1} < -39, Prand(~tuner1Val[6], inf),Pfunc { ~lastMode1 }
							).collect { |mode| ~lastMode1 = mode }
						)},
						\shuffle,{	b = ~tuner1Val[5]; times = b*c;
							Pbindef(\tuner1, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({ d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq= tempfreq.add(d[loop][0]);
										tempmode =tempmode.add(d[loop][1]);
									});
									freqloop=tempfreq;
									modeloop=tempmode;

								}),inf,\step),
								\frequency,Pif(Pfunc{~ad1} < -39,Pn(Plazy({Pseq(freqloop,1)}),inf),Pfunc{~lastFrequency1}
								).collect { |freqs| ~lastFrequency1 = freqs},
								\mode, Pif(Pfunc{~ad1} < -39, Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastMode1 }
								).collect { |modes| ~lastMode1 = modes }
						)},
						\randlist,{Pbindef(\tuner1, \stickyfunc, Pn(Plazy({randlist = a.choose;
							freqrand = randlist[0];
							moderand = randlist[1]
						}),inf),
						\frequency,Pif(Pfunc{~ad1} < -39, Pn(Plazy({freqrand}),inf),Pfunc { ~lastFrequency1 }
						).collect { |freqs| ~lastFrequency1 = freqs },
						\mode,Pif(Pfunc{~ad1} < -39,Pn(Plazy({moderand}),inf),Pfunc { ~lastMode1 }
						).collect { |modes| ~lastMode1 = modes })},
						\loop, {looparray =~tuner1Val[4].flat;
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber, {tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq;
							modeloop = tempmode;
							Pbindef(\tuner1, \stickyfunc, 1, \frequency,Pif(Pfunc{~ad1} < -39, Pn(Plazy({Pseq(freqloop,1)}),inf),						Pfunc { ~lastFrequency1 }
							).collect { |freqs| ~lastFrequency1 = freqs },
							\mode, Pif(Pfunc{~ad1} < -39,  Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastMode1 }
							).collect { |modes| ~lastMode1 = modes }
							)
						}
					);
				}
				);
		});
	});

	~tuner2Set=({
		var l; var times; var g; var t; var x; var d; var tempfreq; var tempmode; var loop; var freqshuf; var modeshuf;
		var randlist; var looparray; var freqloop; var modeloop; var freqrand; var moderand;
		var freq=[1,2];
		var a;
		var c;
		var b= 1;
		var mode= [\am,\fm];
		var v;
		if ((~tuner2Val[1].isNumber == false) && (~tuner2Val[1].isArray == false),
			{~tuner2Val = ~tuner2Val.insert(1,1)});

		v = ~tuner2Val[1];
		if (v.size > 1,
			{
				t =~arrayRange.value(v[0],v[1],v[2]);

				x = t.size-1;
		});


		a = ~tuner2Val[4];
		c = (a.size)/2;
		~tuner2Pat = Pbindef(\tuner2,
			\gate, 1,
			\stickyfunc, 1,
			\dur, 1,
			\mode,\am,
			\frequency, 100,
			\destination, ~targetAddress,
			\id, 'tuner2',
			\voice, 1,
			\play, ~oscTransmitter
		);
		switch (~tuner2Val[0],
			\silentlatch, {Pbindef(\tuner2,\dur,Pfunc({~adDur2}))},
			\latch, 	  {Pbindef(\tuner2,\dur,Pfunc({~adDur2}))},
			\const, 	  {Pbindef(\tuner2,\dur,v)},
			\rand,  	  {Pbindef(\tuner2,\dur, Prand(t,inf))},
			\drunk, 	  {Pbindef(\tuner2,\dur, Pwalk(t,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2))},
			\dec, 		  {Pbindef(\tuner2,\dur,Pwalk(t,Pseq([1], inf),Pseq([1, -1],inf),0))},
			\acc, 		  {Pbindef(\tuner2,\dur,Pwalk(t,Pseq([1], inf),Pseq([-1, 1], inf),x))},
		);
		if (~tuner2Val[0] !== \silentlatch,
			//if silentlatch
			{
				if(~tuner2Val[3] == \free,{
					switch (~tuner2Val[2],
						\randrange, {Pbindef(\tuner2,\frequency, Pwhite(a[0],a[1],inf),
							\mode, Prand(~tuner2Val[5],inf)
						)},
						\scanner, { l = ~tuner2Val[5]; g = ~tuner2Val[5].size - 1;
							Pbindef(\tuner2, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),																          			  Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
								\mode, Prand(~tuner2Val[6], inf)
						)},
						\shuffle, { b = ~tuner2Val[5];
							Pbindef(\tuner2, \frequency, Pn(Pshuf(a,b),inf),
								\mode, Prand(~tuner2Val[6],inf)
						)},
						\randlist,  {Pbindef(\tuner2, \frequency, Prand(a, inf),
							\mode, Prand(~tuner2Val[5],inf)
						)},
						\loop, 		{Pbindef(\tuner2, \frequency, Pseq(a, inf),
							\mode, Prand(~tuner2Val[5],inf)
						)}
					)
				},
				{
					a = ~tuner2Val[4].clump(2);
					switch (~tuner2Val[2],
						\randrange, {a = a.flat;
							Pbindef(\tuner2,\frequency, Pwhite(a[0],a[1],inf),
								\mode, Prand(~tuner2Val[5], inf)
						)},
						\scanner, { a = a.flat; l = ~tuner2Val[5]; g = ~tuner2Val[5].size - 1;
							Pbindef(\tuner2, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),
								Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
							\mode, Prand(~tuner2Val[6], inf)
						)},
						\shuffle, {	b = ~tuner2Val[5]; times = b*c;
							Pbindef(\tuner2, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({
									d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq = tempfreq.add(d[loop][0]);
										tempmode = tempmode.add(d[loop][1]);});
									freqshuf = tempfreq; modeshuf = tempmode;
								}),inf,\step),
								\frequency, Pn(Plazy({Pseq(freqshuf,1)}),inf),
								\mode, Pn(Plazy({Pseq(modeshuf,1)}),inf)
						)},
						\randlist,{ Pbindef(\tuner2, \stickyfunc, Pn(Plazy({
							randlist = a.choose;
							freq=randlist[0];
							mode=randlist[1]
						}),inf),
						\frequency, Pn(Plazy({freq}),inf),
						\mode,Pn(Plazy({mode}),inf)
						)},
						\loop, { looparray =~tuner2Val[4];
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber,
									{tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq; modeloop = tempmode;
							Pbindef(\tuner2, \stickyfunc, 1,
								\frequency, Pn(Plazy({Pseq(freqloop,1)}),inf),
								\mode,  Pn(Plazy({Pseq(modeloop,1)}),inf)
						)}
					)
				})
			},
			{
				if ( ~tuner2Val[3] == \free,{
					switch (~tuner2Val[2],
						\randrange, {Pbindef(\tuner2,\frequency, Pif(Pfunc{~ad2} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequency2 }
						).collect { |freqs| ~lastFrequency2 = freqs },
						\mode, Pif(Pfunc{~ad2} < -39, Prand(~tuner2Val[5],inf),Pfunc { ~lastMode2 }
						).collect { |modes| ~lastMode2 = modes }
						)},
						\scanner, { l = ~tuner2Val[5]; g = ~tuner2Val[5].size - 1;
							Pbindef(\tuner2, \frequency,Pif(Pfunc{~ad2} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequency2}
							).collect { |freqs| ~lastFrequency2 = freqs },
							\mode, Pif(Pfunc{~ad2} < -39, Prand(~tuner2Val[6], inf),Pfunc { ~lastMode2 }
							).collect { |modes| ~lastMode2 = modes }
						)},
						\shuffle, { b =~tuner2Val[5];
							Pbindef(\tuner2, \frequency,Pif(Pfunc{~ad2} < -39, Pn(Pshuf(a,b),inf),Pfunc { ~lastFrequency2 }
							).collect { |freqs| ~lastFrequency2 = freqs },
							\mode, Pif(Pfunc{~ad2} < -39, Prand(~tuner2Val[6],inf),Pfunc { ~lastMode2 }
							).collect { |modes| ~lastMode2 = modes }
						)},
						\randlist, {Pbindef(\tuner2, \frequency, Pif(Pfunc{~ad2} < -39, Prand(a, inf),Pfunc { ~lastFrequency2 }
						).collect { |freqs| ~lastFrequency2 = freqs },
						\mode, Pif(Pfunc{~ad2} < -39, Prand(~tuner2Val[5],inf),Pfunc { ~lastMode2 }
						).collect { |modes| ~lastMode2 = modes }
						)},
						\loop, {Pbindef(\tuner2, \frequency, Pif(Pfunc{~ad2} < -39, Pseq(a, inf),Pfunc { ~lastFrequency2 }
						).collect { |freqs| ~lastFrequency2 = freqs },
						\mode, Pif(Pfunc{~ad2} < -39, Prand(~tuner2Val[5],inf),Pfunc { ~lastMode2 }
						).collect { |modes| ~lastMode2 = modes }
						)}
					)
				}
				,
				{
					a = ~tuner2Val[4].clump(2);
					switch (~tuner2Val[2],
						\randrange, {a = a.flat;
							Pbindef(\tuner2,\frequency, Pif(Pfunc{~ad2} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequency2 }
							).collect { |freqs| ~lastFrequency2 = freqs },
							\mode, Pif(Pfunc{~ad2} < -39, Prand(~tuner2Val[5],inf),Pfunc { ~lastMode2 }
							).collect { |modes| ~lastMode2 = modes }
						)},
						\scanner, {a = a.flat; l = ~tuner2Val[5]; g = ~tuner2Val[5].size - 1;
							Pbindef(\tuner2, \frequency,Pif(Pfunc{~ad2} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequency2}
							).collect { |freqs| ~lastFrequency2 = freqs },
							\mode, Pif(Pfunc{~ad2} < -39, Prand(~tuner2Val[6], inf),Pfunc { ~lastMode2 }
							).collect { |mode| ~lastMode2 = mode }
						)},
						\shuffle,{	b = ~tuner2Val[5]; times = b*c;
							Pbindef(\tuner2, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({ d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq= tempfreq.add(d[loop][0]);
										tempmode =tempmode.add(d[loop][1]);
									});
									freqloop=tempfreq;
									modeloop=tempmode;

								}),inf,\step),
								\frequency,Pif(Pfunc{~ad2} < -39,Pn(Plazy({Pseq(freqloop,1)}),inf),Pfunc{~lastFrequency2}
								).collect { |freqs| ~lastFrequency2 = freqs},
								\mode, Pif(Pfunc{~ad2} < -39, Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastMode2 }
								).collect { |modes| ~lastMode2 = modes }
						)},
						\randlist,{Pbindef(\tuner2, \stickyfunc, Pn(Plazy({randlist = a.choose;
							freqrand = randlist[0];
							moderand = randlist[1]
						}),inf),
						\frequency,Pif(Pfunc{~ad2} < -39, Pn(Plazy({freqrand}),inf),Pfunc { ~lastFrequency2 }
						).collect { |freqs| ~lastFrequency2 = freqs },
						\mode,Pif(Pfunc{~ad2} < -39,Pn(Plazy({moderand}),inf),Pfunc { ~lastMode2 }
						).collect { |modes| ~lastMode2 = modes })},
						\loop, {looparray =~tuner2Val[4].flat;
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber, {tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq;
							modeloop = tempmode;
							Pbindef(\tuner2, \stickyfunc, 1, \frequency,Pif(Pfunc{~ad2} < -39, Pn(Plazy({Pseq(freqloop,1)}),inf),						Pfunc { ~lastFrequency2 }
							).collect { |freqs| ~lastFrequency2 = freqs },
							\mode, Pif(Pfunc{~ad2} < -39,  Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastMode2 }
							).collect { |modes| ~lastMode2 = modes }
							)
						}
					);
				}
				);
		});
	});

	~tuner3Set=({
		var l; var times; var g; var t; var x; var d; var tempfreq; var tempmode; var loop; var freqshuf; var modeshuf;
		var randlist; var looparray; var freqloop; var modeloop; var freqrand; var moderand;
		var freq=[1,2];
		var a;
		var c;
		var b= 1;
		var mode= [\am,\fm];
		var v;
		if ((~tuner3Val[1].isNumber == false) && (~tuner3Val[1].isArray == false),
			{~tuner3Val = ~tuner3Val.insert(1,1)});

		v = ~tuner3Val[1];
		if (v.size > 1,
			{
				t =~arrayRange.value(v[0],v[1],v[2]);

				x = t.size-1;
		});


		a = ~tuner3Val[4];
		c = (a.size)/2;
		~tuner3Pat = Pbindef(\tuner3,
			\gate, 1,
			\stickyfunc, 1,
			\dur, 1,
			\mode,\am,
			\frequency, 100,
			\destination, ~targetAddress,
			\id, 'tuner3',
			\voice, 2,
			\play, ~oscTransmitter
		);
		switch (~tuner3Val[0],
			\silentlatch, {Pbindef(\tuner3,\dur,Pfunc({~adDur3}))},
			\latch, 	  {Pbindef(\tuner3,\dur,Pfunc({~adDur3}))},
			\const, 	  {Pbindef(\tuner3,\dur,v)},
			\rand,  	  {Pbindef(\tuner3,\dur, Prand(t,inf))},
			\drunk, 	  {Pbindef(\tuner3,\dur, Pwalk(t,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2))},
			\dec, 		  {Pbindef(\tuner3,\dur,Pwalk(t,Pseq([1], inf),Pseq([1, -1],inf),0))},
			\acc, 		  {Pbindef(\tuner3,\dur,Pwalk(t,Pseq([1], inf),Pseq([-1, 1], inf),x))},
		);
		if (~tuner3Val[0] !== \silentlatch,
			//if silentlatch
			{
				if(~tuner3Val[3] == \free,{
					switch (~tuner3Val[2],
						\randrange, {Pbindef(\tuner3,\frequency, Pwhite(a[0],a[1],inf),
							\mode, Prand(~tuner3Val[5],inf)
						)},
						\scanner, { l = ~tuner3Val[5]; g = ~tuner3Val[5].size - 1;
							Pbindef(\tuner3, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),																          			  Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
								\mode, Prand(~tuner3Val[6], inf)
						)},
						\shuffle, { b = ~tuner3Val[5];
							Pbindef(\tuner3, \frequency, Pn(Pshuf(a,b),inf),
								\mode, Prand(~tuner3Val[6],inf)
						)},
						\randlist,  {Pbindef(\tuner3, \frequency, Prand(a, inf),
							\mode, Prand(~tuner3Val[5],inf)
						)},
						\loop, 		{Pbindef(\tuner3, \frequency, Pseq(a, inf),
							\mode, Prand(~tuner3Val[5],inf)
						)}
					)
				},
				{
					a = ~tuner3Val[4].clump(2);
					switch (~tuner3Val[2],
						\randrange, {a = a.flat;
							Pbindef(\tuner3,\frequency, Pwhite(a[0],a[1],inf),
								\mode, Prand(~tuner3Val[5], inf)
						)},
						\scanner, { a = a.flat; l = ~tuner3Val[5]; g = ~tuner3Val[5].size - 1;
							Pbindef(\tuner3, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),
								Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
							\mode, Prand(~tuner3Val[6], inf)
						)},
						\shuffle, {	b = ~tuner3Val[5]; times = b*c;
							Pbindef(\tuner3, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({
									d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq = tempfreq.add(d[loop][0]);
										tempmode = tempmode.add(d[loop][1]);});
									freqshuf = tempfreq; modeshuf = tempmode;
								}),inf,\step),
								\frequency, Pn(Plazy({Pseq(freqshuf,1)}),inf),
								\mode, Pn(Plazy({Pseq(modeshuf,1)}),inf)
						)},
						\randlist,{ Pbindef(\tuner3, \stickyfunc, Pn(Plazy({
							randlist = a.choose;
							freq=randlist[0];
							mode=randlist[1]
						}),inf),
						\frequency, Pn(Plazy({freq}),inf),
						\mode,Pn(Plazy({mode}),inf)
						)},
						\loop, { looparray =~tuner3Val[4];
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber,
									{tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq; modeloop = tempmode;
							Pbindef(\tuner3, \stickyfunc, 1,
								\frequency, Pn(Plazy({Pseq(freqloop,1)}),inf),
								\mode,  Pn(Plazy({Pseq(modeloop,1)}),inf)
						)}
					)
				})
			},
			{
				if ( ~tuner3Val[3] == \free,{
					switch (~tuner3Val[2],
						\randrange, {Pbindef(\tuner3,\frequency, Pif(Pfunc{~ad1} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequency3 }
						).collect { |freqs| ~lastFrequency3 = freqs },
						\mode, Pif(Pfunc{~ad3} < -39, Prand(~tuner3Val[5],inf),Pfunc { ~lastMode3 }
						).collect { |modes| ~lastMode3 = modes }
						)},
						\scanner, { l = ~tuner3Val[5]; g = ~tuner3Val[5].size - 1;
							Pbindef(\tuner3, \frequency,Pif(Pfunc{~ad3} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequency3}
							).collect { |freqs| ~lastFrequency3 = freqs },
							\mode, Pif(Pfunc{~ad3} < -39, Prand(~tuner3Val[6], inf),Pfunc { ~lastMode3 }
							).collect { |modes| ~lastMode3 = modes }
						)},
						\shuffle, { b =~tuner3Val[5];
							Pbindef(\tuner3, \frequency,Pif(Pfunc{~ad3} < -39, Pn(Pshuf(a,b),inf),Pfunc { ~lastFrequency3 }
							).collect { |freqs| ~lastFrequency3 = freqs },
							\mode, Pif(Pfunc{~ad3} < -39, Prand(~tuner3Val[6],inf),Pfunc { ~lastMode3 }
							).collect { |modes| ~lastMode3 = modes }
						)},
						\randlist, {Pbindef(\tuner3, \frequency, Pif(Pfunc{~ad3} < -39, Prand(a, inf),Pfunc { ~lastFrequency3 }
						).collect { |freqs| ~lastFrequency3 = freqs },
						\mode, Pif(Pfunc{~ad3} < -39, Prand(~tuner3Val[5],inf),Pfunc { ~lastMode3 }
						).collect { |modes| ~lastMode3 = modes }
						)},
						\loop, {Pbindef(\tuner3, \frequency, Pif(Pfunc{~ad3} < -39, Pseq(a, inf),Pfunc { ~lastFrequency3 }
						).collect { |freqs| ~lastFrequency3 = freqs },
						\mode, Pif(Pfunc{~ad3} < -39, Prand(~tuner3Val[5],inf),Pfunc { ~lastMode3 }
						).collect { |modes| ~lastMode3 = modes }
						)}
					)
				}
				,
				{
					a = ~tuner3Val[4].clump(2);
					switch (~tuner3Val[2],
						\randrange, {a = a.flat;
							Pbindef(\tuner3,\frequency, Pif(Pfunc{~ad3} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequency3 }
							).collect { |freqs| ~lastFrequency3 = freqs },
							\mode, Pif(Pfunc{~ad3} < -39, Prand(~tuner3Val[5],inf),Pfunc { ~lastMode3 }
							).collect { |modes| ~lastMode3 = modes }
						)},
						\scanner, {a = a.flat; l = ~tuner3Val[5]; g = ~tuner3Val[5].size - 1;
							Pbindef(\tuner3, \frequency,Pif(Pfunc{~ad3} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequency3}
							).collect { |freqs| ~lastFrequency3 = freqs },
							\mode, Pif(Pfunc{~ad3} < -39, Prand(~tuner3Val[6], inf),Pfunc { ~lastMode3 }
							).collect { |mode| ~lastMode3 = mode }
						)},
						\shuffle,{	b = ~tuner3Val[5]; times = b*c;
							Pbindef(\tuner3, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({ d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq= tempfreq.add(d[loop][0]);
										tempmode =tempmode.add(d[loop][1]);
									});
									freqloop=tempfreq;
									modeloop=tempmode;

								}),inf,\step),
								\frequency,Pif(Pfunc{~ad3} < -39,Pn(Plazy({Pseq(freqloop,1)}),inf),Pfunc{~lastFrequency3}
								).collect { |freqs| ~lastFrequency3 = freqs},
								\mode, Pif(Pfunc{~ad3} < -39, Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastMode3 }
								).collect { |modes| ~lastMode3 = modes }
						)},
						\randlist,{Pbindef(\tuner3, \stickyfunc, Pn(Plazy({randlist = a.choose;
							freqrand = randlist[0];
							moderand = randlist[1]
						}),inf),
						\frequency,Pif(Pfunc{~ad3} < -39, Pn(Plazy({freqrand}),inf),Pfunc { ~lastFrequency3 }
						).collect { |freqs| ~lastFrequency3 = freqs },
						\mode,Pif(Pfunc{~ad3} < -39,Pn(Plazy({moderand}),inf),Pfunc { ~lastMode3 }
						).collect { |modes| ~lastMode3 = modes })},
						\loop, {looparray =~tuner3Val[4].flat;
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber, {tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq;
							modeloop = tempmode;
							Pbindef(\tuner3, \stickyfunc, 1, \frequency,Pif(Pfunc{~ad3} < -39, Pn(Plazy({Pseq(freqloop,1)}),inf),						Pfunc { ~lastFrequency3 }
							).collect { |freqs| ~lastFrequency3 = freqs },
							\mode, Pif(Pfunc{~ad3} < -39,  Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastMode3 }
							).collect { |modes| ~lastMode3 = modes }
							)
						}
					);
				}
				);
		});
	});

~tuner4Set=({
		var l; var times; var g; var t; var x; var d; var tempfreq; var tempmode; var loop; var freqshuf; var modeshuf;
		var randlist; var looparray; var freqloop; var modeloop; var freqrand; var moderand;
		var freq=[1,2];
		var a;
		var c;
		var b= 1;
		var mode= [\am,\fm];
		var v;
		if ((~tuner4Val[1].isNumber == false) && (~tuner4Val[1].isArray == false),
			{~tuner4Val = ~tuner4Val.insert(1,1)});

		v = ~tuner4Val[1];
		if (v.size > 1,
			{
				t =~arrayRange.value(v[0],v[1],v[2]);
				x = t.size-1;
		});
		a = ~tuner4Val[4];
		c = (a.size)/2;
		~tuner4Pat = Pbindef(\tuner4,
			\gate, 1,
			\stickyfunc, 1,
			\dur, 1,
			\mode,\am,
			\frequency, 100,
			\destination, ~targetAddress,
			\id, 'tuner1',
			\voice, 3,
			\play, ~oscTransmitter
		);
		switch (~tuner4Val[0],
			\silentlatch, {Pbindef(\tuner4,\dur,Pfunc({~adDur4}))},
			\latch, 	  {Pbindef(\tuner4,\dur,Pfunc({~adDur4}))},
			\const, 	  {Pbindef(\tuner4,\dur,v)},
			\rand,  	  {Pbindef(\tuner4,\dur, Prand(t,inf))},
			\drunk, 	  {Pbindef(\tuner4,\dur, Pwalk(t,Pwhite(-2,2,inf), Pseq([1,-1],inf),x/2))},
			\dec, 		  {Pbindef(\tuner4,\dur,Pwalk(t,Pseq([1], inf),Pseq([1, -1],inf),0))},
			\acc, 		  {Pbindef(\tuner4,\dur,Pwalk(t,Pseq([1], inf),Pseq([-1, 1], inf),x))},
		);
		if (~tuner4Val[0] !== \silentlatch,
			//if silentlatch
			{
				if(~tuner4Val[3] == \free,{
					switch (~tuner4Val[2],
						\randrange, {Pbindef(\tuner4,\frequency, Pwhite(a[0],a[1],inf),
							\mode, Prand(~tuner4Val[5],inf)
						)},
						\scanner, { l = ~tuner4Val[5]; g = ~tuner4Val[5].size - 1;
							Pbindef(\tuner4, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),																          			  Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
								\mode, Prand(~tuner4Val[6], inf)
						)},
						\shuffle, { b = ~tuner4Val[5];
							Pbindef(\tuner4, \frequency, Pn(Pshuf(a,b),inf),
								\mode, Prand(~tuner4Val[6],inf)
						)},
						\randlist,  {Pbindef(\tuner4, \frequency, Prand(a, inf),
							\mode, Prand(~tuner4Val[5],inf)
						)},
						\loop, 		{Pbindef(\tuner4, \frequency, Pseq(a, inf),
							\mode, Prand(~tuner4Val[5],inf)
						)}
					)
				},
				{
					a = ~tuner4Val[4].clump(2);
					switch (~tuner4Val[2],
						\randrange, {a = a.flat;
							Pbindef(\tuner4,\frequency, Pwhite(a[0],a[1],inf),
								\mode, Prand(~tuner4Val[5], inf)
						)},
						\scanner, { a = a.flat; l = ~tuner4Val[5]; g = ~tuner4Val[5].size - 1;
							Pbindef(\tuner4, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),
								Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
							\mode, Prand(~tuner4Val[6], inf)
						)},
						\shuffle, {	b = ~tuner4Val[5]; times = b*c;
							Pbindef(\tuner4, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({
									d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq = tempfreq.add(d[loop][0]);
										tempmode = tempmode.add(d[loop][1]);});
									freqshuf = tempfreq; modeshuf = tempmode;
								}),inf,\step),
								\frequency, Pn(Plazy({Pseq(freqshuf,1)}),inf),
								\mode, Pn(Plazy({Pseq(modeshuf,1)}),inf)
						)},
						\randlist,{ Pbindef(\tuner4, \stickyfunc, Pn(Plazy({
							randlist = a.choose;
							freq=randlist[0];
							mode=randlist[1]
						}),inf),
						\frequency, Pn(Plazy({freq}),inf),
						\mode,Pn(Plazy({mode}),inf)
						)},
						\loop, { looparray =~tuner4Val[4];
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber,
									{tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq; modeloop = tempmode;
							Pbindef(\tuner4, \stickyfunc, 1,
								\frequency, Pn(Plazy({Pseq(freqloop,1)}),inf),
								\mode,  Pn(Plazy({Pseq(modeloop,1)}),inf)
						)}
					)
				})
			},
			{
				if ( ~tuner4Val[3] == \free,{
					switch (~tuner4Val[2],
						\randrange, {Pbindef(\tuner4,\frequency, Pif(Pfunc{~ad4} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequency4 }
						).collect { |freqs| ~lastFrequency4 = freqs },
						\mode, Pif(Pfunc{~ad4} < -39, Prand(~tuner4Val[5],inf),Pfunc { ~lastMode4 }
						).collect { |modes| ~lastMode4 = modes }
						)},
						\scanner, { l = ~tuner4Val[5]; g = ~tuner4Val[5].size - 1;
							Pbindef(\tuner4, \frequency,Pif(Pfunc{~ad4} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequency4}
							).collect { |freqs| ~lastFrequency4 = freqs },
							\mode, Pif(Pfunc{~ad4} < -39, Prand(~tuner4Val[6], inf),Pfunc { ~lastMode4 }
							).collect { |modes| ~lastMode4 = modes }
						)},
						\shuffle, { b =~tuner4Val[5];
							Pbindef(\tuner4, \frequency,Pif(Pfunc{~ad4} < -39, Pn(Pshuf(a,b),inf),Pfunc { ~lastFrequency4 }
							).collect { |freqs| ~lastFrequency4 = freqs },
							\mode, Pif(Pfunc{~ad4} < -39, Prand(~tuner4Val[6],inf),Pfunc { ~lastMode4 }
							).collect { |modes| ~lastMode4 = modes }
						)},
						\randlist, {Pbindef(\tuner4, \frequency, Pif(Pfunc{~ad4} < -39, Prand(a, inf),Pfunc { ~lastFrequency4 }
						).collect { |freqs| ~lastFrequency4 = freqs },
						\mode, Pif(Pfunc{~ad4} < -39, Prand(~tuner4Val[5],inf),Pfunc { ~lastMode4 }
						).collect { |modes| ~lastMode4 = modes }
						)},
						\loop, {Pbindef(\tuner4, \frequency, Pif(Pfunc{~ad4} < -39, Pseq(a, inf),Pfunc { ~lastFrequency4 }
						).collect { |freqs| ~lastFrequency4 = freqs },
						\mode, Pif(Pfunc{~ad4} < -39, Prand(~tuner4Val[5],inf),Pfunc { ~lastMode4 }
						).collect { |modes| ~lastMode4 = modes }
						)}
					)
				}
				,
				{
					a = ~tuner4Val[4].clump(2);
					switch (~tuner4Val[2],
						\randrange, {a = a.flat;
							Pbindef(\tuner4,\frequency, Pif(Pfunc{~ad4} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequency4 }
							).collect { |freqs| ~lastFrequency4 = freqs },
							\mode, Pif(Pfunc{~ad4} < -39, Prand(~tuner4Val[5],inf),Pfunc { ~lastMode4 }
							).collect { |modes| ~lastMode4 = modes }
						)},
						\scanner, {a = a.flat; l = ~tuner4Val[5]; g = ~tuner4Val[5].size - 1;
							Pbindef(\tuner4, \frequency,Pif(Pfunc{~ad4} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequency4}
							).collect { |freqs| ~lastFrequency4 = freqs },
							\mode, Pif(Pfunc{~ad4} < -39, Prand(~tuner4Val[6], inf),Pfunc { ~lastMode4 }
							).collect { |mode| ~lastMode4 = mode }
						)},
						\shuffle,{	b = ~tuner4Val[5]; times = b*c;
							Pbindef(\tuner4, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({ d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq= tempfreq.add(d[loop][0]);
										tempmode =tempmode.add(d[loop][1]);
									});
									freqloop=tempfreq;
									modeloop=tempmode;

								}),inf,\step),
								\frequency,Pif(Pfunc{~ad4} < -39,Pn(Plazy({Pseq(freqloop,1)}),inf),Pfunc{~lastFrequency4}
								).collect { |freqs| ~lastFrequency4 = freqs},
								\mode, Pif(Pfunc{~ad4} < -39, Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastMode4 }
								).collect { |modes| ~lastMode4 = modes }
						)},
						\randlist,{Pbindef(\tuner4, \stickyfunc, Pn(Plazy({randlist = a.choose;
							freqrand = randlist[0];
							moderand = randlist[1]
						}),inf),
						\frequency,Pif(Pfunc{~ad4} < -39, Pn(Plazy({freqrand}),inf),Pfunc { ~lastFrequency4 }
						).collect { |freqs| ~lastFrequency4 = freqs },
						\mode,Pif(Pfunc{~ad4} < -39,Pn(Plazy({moderand}),inf),Pfunc { ~lastMode4 }
						).collect { |modes| ~lastMode4 = modes })},
						\loop, {looparray =~tuner4Val[4].flat;
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber, {tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq;
							modeloop = tempmode;
							Pbindef(\tuner4, \stickyfunc, 1, \frequency,Pif(Pfunc{~ad4} < -39, Pn(Plazy({Pseq(freqloop,1)}),inf),						Pfunc { ~lastFrequency4 }
							).collect { |freqs| ~lastFrequency4 = freqs },
							\mode, Pif(Pfunc{~ad4} < -39,  Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastMode4 }
							).collect { |modes| ~lastMode4 = modes }
							)
						}
					);
				}
				);
		});
	});

	~tunerMonoSet=({
		var l; var times; var g; var t; var x; var d; var tempfreq; var tempmode; var loop; var freqshuf; var modeshuf;
		var randlist; var looparray; var freqloop; var modeloop; var freqrand; var moderand;
		var freq=[1,2];
		var a;
		var c;
		var b= 1;
		var mode= [\am,\fm];
		var v;
		if ((~tunerMonoVal[1].isNumber == false) && (~tunerMonoVal[1].isArray == false),
			{~tunerMonoVal = ~tunerMonoVal.insert(1,1)});

		v = ~tunerMonoVal[1];
		if (v.size > 1,
			{
				t =~arrayRange.value(v[0],v[1],v[2]);
				x = t.size-1;
		});
		a = ~tunerMonoVal[4];
		c = (a.size)/2;
		~tunerMonoPat = Pbindef(\tunerMono,
			\gate, 1,
			\stickyfunc, 1,
			\dur, 1,
			\mode,\am,
			\frequency, 100,
			\destination, ~targetAddress,
			\id, 'tunerMono',
			\voice, Pfunc{~adMonoVoice},
			\play, ~oscTransmitter
		);
		switch (~tunerMonoVal[0],
			\silentlatch, {Pbindef(\tunerMono,\dur,Pfunc({~adDurMono}),
				\voice, Pfunc{~adMonoVoice}
			)},
			\latch, 	  {Pbindef(\tunerMono,\dur,Pfunc({~adDurMono}),
				\voice, Pfunc{~adMonoVoice}
			)},
			\const, 	  {Pbindef(\tunerMono,\dur,v,
				\voice, Pseq([Pseries (0, 1, 4)], inf))},
			\rand,  	  {Pbindef(\tunerMono,\dur, Prand(t,inf),
				\voice, Pseq([Pseries (0, 1, 4)], inf))},
			\drunk, 	  {Pbindef(\tunerMono,\dur, Pwalk(t,Pwhite(-2,2,inf),	Pseq([1,-1],inf),x/2),
				\voice, Pseq([Pseries (0, 1, 4)], inf))},
			\dec, 		  {Pbindef(\tunerMono,\dur,Pwalk(t,Pseq([1], inf),Pseq([1, -1],inf),0),
				\voice, Pseq([Pseries (0, 1, 4)], inf))},
			\acc, 		  {Pbindef(\tunerMono,\dur,Pwalk(t,Pseq([1], inf),Pseq([-1, 1], inf),x),
				\voice, Pseq([Pseries (0, 1, 4)], inf))},
		);
		if (~tunerMonoVal[0] !== \silentlatch,
			//if silentlatch
			{
				if(~tunerMonoVal[3] == \free,{
					switch (~tunerMonoVal[2],
						\randrange, {Pbindef(\tunerMono,\frequency, Pwhite(a[0],a[1],inf),
							\mode, Prand(~tunerMonoVal[5],inf)
						)},
						\scanner, { l = ~tunerMonoVal[5]; g = ~tunerMonoVal[5].size - 1;
							Pbindef(\tunerMono, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),																          			  Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
								\mode, Prand(~tunerMonoVal[6], inf)
						)},
						\shuffle, { b = ~tunerMonoVal[5];
							Pbindef(\tunerMono, \frequency, Pn(Pshuf(a,b),inf),
								\mode, Prand(~tunerMonoVal[6],inf)
						)},
						\randlist,  {Pbindef(\tunerMono, \frequency, Prand(a, inf),
							\mode, Prand(~tunerMonoVal[5],inf)
						)},
						\loop, 		{Pbindef(\tunerMono, \frequency, Pseq(a, inf),
							\mode, Prand(~tunerMonoVal[5],inf)
						)}
					)
				},
				{
					a = ~tunerMonoVal[4].clump(2);
					switch (~tunerMonoVal[2],
						\randrange, {a = a.flat;
							Pbindef(\tunerMono,\frequency, Pwhite(a[0],a[1],inf),
								\mode, Prand(~tunerMonoVal[5], inf)
						)},
						\scanner, { a = a.flat; l = ~tunerMonoVal[5]; g = ~tunerMonoVal[5].size - 1;
							Pbindef(\tunerMono, \frequency, Pseg([a[0], a[1], a[1], a[2]], [Pwhite( l[0],  l[1],1),
								Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),
							\mode, Prand(~tunerMonoVal[6], inf)
						)},
						\shuffle, {	b = ~tunerMonoVal[5]; times = b*c;
							Pbindef(\tunerMono, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({
									d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq = tempfreq.add(d[loop][0]);
										tempmode = tempmode.add(d[loop][1]);});
									freqshuf = tempfreq; modeshuf = tempmode;
								}),inf,\step),
								\frequency, Pn(Plazy({Pseq(freqshuf,1)}),inf),
								\mode, Pn(Plazy({Pseq(modeshuf,1)}),inf)
						)},
						\randlist,{ Pbindef(\tunerMono, \stickyfunc, Pn(Plazy({
							randlist = a.choose;
							freq=randlist[0];
							mode=randlist[1]
						}),inf),
						\frequency, Pn(Plazy({freq}),inf),
						\mode,Pn(Plazy({mode}),inf)
						)},
						\loop, { looparray =~tunerMonoVal[4];
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber,
									{tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq; modeloop = tempmode;
							Pbindef(\tunerMono, \stickyfunc, 1,
								\frequency, Pn(Plazy({Pseq(freqloop,1)}),inf),
								\mode,  Pn(Plazy({Pseq(modeloop,1)}),inf)
						)}
					)
				})
			},
			{
				if ( ~tunerMonoVal[3] == \free,{
					switch (~tunerMonoVal[2],
						\randrange, {Pbindef(\tunerMono,\frequency, Pif(Pfunc{~adMono} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequencyMono }
						).collect { |freqs| ~lastFrequencyMono = freqs },
						\mode, Pif(Pfunc{~adMono} < -39, Prand(~tunerMonoVal[5],inf),Pfunc { ~lastModeMono }
						).collect { |modes| ~lastModeMono = modes }
						)},
						\scanner, { l = ~tunerMonoVal[5]; g = ~tunerMonoVal[5].size - 1;
							Pbindef(\tunerMono, \frequency,Pif(Pfunc{~adMono} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequencyMono}
							).collect { |freqs| ~lastFrequencyMono = freqs },
							\mode, Pif(Pfunc{~adMono} < -39, Prand(~tunerMonoVal[6], inf),Pfunc { ~lastModeMono }
							).collect { |modes| ~lastModeMono = modes }
						)},
						\shuffle, { b =~tunerMonoVal[5];
							Pbindef(\tunerMono, \frequency,Pif(Pfunc{~adMono} < -39, Pn(Pshuf(a,b),inf),Pfunc { ~lastFrequencyMono }
							).collect { |freqs| ~lastFrequencyMono = freqs },
							\mode, Pif(Pfunc{~adMono} < -39, Prand(~tunerMonoVal[6],inf),Pfunc { ~lastModeMono }
							).collect { |modes| ~lastModeMono = modes }
						)},
						\randlist, {Pbindef(\tunerMono, \frequency, Pif(Pfunc{~adMono} < -39, Prand(a, inf),Pfunc { ~lastFrequencyMono }
						).collect { |freqs| ~lastFrequencyMono = freqs },
						\mode, Pif(Pfunc{~adMono} < -39, Prand(~tunerMonoVal[5],inf),Pfunc { ~lastModeMono }
						).collect { |modes| ~lastModeMono = modes }
						)},
						\loop, {Pbindef(\tunerMono, \frequency, Pif(Pfunc{~adMono} < -39, Pseq(a, inf),Pfunc { ~lastFrequencyMono }
						).collect { |freqs| ~lastFrequencyMono = freqs },
						\mode, Pif(Pfunc{~adMono} < -39, Prand(~tunerMonoVal[5],inf),Pfunc { ~lastModeMono }
						).collect { |modes| ~lastModeMono = modes }
						)}
					)
				}
				,
				{
					a = ~tunerMonoVal[4].clump(2);
					switch (~tunerMonoVal[2],
						\randrange, {a = a.flat;
							Pbindef(\tunerMono,\frequency, Pif(Pfunc{~adMono} < -39,Pwhite(a[0],a[1],inf),Pfunc { ~lastFrequencyMono }
							).collect { |freqs| ~lastFrequencyMono = freqs },
							\mode, Pif(Pfunc{~adMono} < -39, Prand(~tunerMonoVal[5],inf),Pfunc { ~lastModeMono }
							).collect { |modes| ~lastModeMono = modes }
						)},
						\scanner, {a = a.flat; l = ~tunerMonoVal[5]; g = ~tunerMonoVal[5].size - 1;
							Pbindef(\tunerMono, \frequency,Pif(Pfunc{~adMono} < -39, Pseg([a[0], a[1], a[1], a[2]],
								[Pwhite( l[0],  l[1],1),Pwhite( l[2],l[3], 1),Pwhite(l[4], l[5], 1)], g, inf),Pfunc {~lastFrequencyMono}
							).collect { |freqs| ~lastFrequencyMono = freqs },
							\mode, Pif(Pfunc{~adMono} < -39, Prand(~tunerMonoVal[6], inf),Pfunc { ~lastModeMono }
							).collect { |mode| ~lastModeMono = mode }
						)},
						\shuffle,{	b = ~tunerMonoVal[5]; times = b*c;
							Pbindef(\tunerMono, \gate, Pn(Plazy({Pseries(1,1,times)}), inf, \step),
								\stickyfunc, Pgate(Plazy({ d = a.scramble;
									tempfreq = []; tempmode =[];
									times.do({arg i;
										loop = (i-1)%d.size;
										tempfreq= tempfreq.add(d[loop][0]);
										tempmode =tempmode.add(d[loop][1]);
									});
									freqloop=tempfreq;
									modeloop=tempmode;

								}),inf,\step),
								\frequency,Pif(Pfunc{~adMono} < -39,Pn(Plazy({Pseq(freqloop,1)}),inf),Pfunc{~lastFrequencyMono}
								).collect { |freqs| ~lastFrequencyMono = freqs},
								\mode, Pif(Pfunc{~adMono} < -39, Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastModeMono }
								).collect { |modes| ~lastModeMono = modes }
						)},
						\randlist,{Pbindef(\tunerMono, \stickyfunc, Pn(Plazy({randlist = a.choose;
							freqrand = randlist[0];
							moderand = randlist[1]
						}),inf),
						\frequency,Pif(Pfunc{~adMono} < -39, Pn(Plazy({freqrand}),inf),Pfunc { ~lastFrequencyMono }
						).collect { |freqs| ~lastFrequencyMono = freqs },
						\mode,Pif(Pfunc{~adMono} < -39,Pn(Plazy({moderand}),inf),Pfunc { ~lastModeMono }
						).collect { |modes| ~lastModeMono = modes })},
						\loop, {looparray =~tunerMonoVal[4].flat;
							tempfreq = []; tempmode =[];
							looparray.do{arg item, i;
								if (item.isNumber, {tempfreq = tempfreq.add(item)},
									{tempmode = tempmode.add(item)}
								);
							};
							freqloop = tempfreq;
							modeloop = tempmode;
							Pbindef(\tunerMono, \stickyfunc, 1, \frequency,Pif(Pfunc{~adMono} < -39, Pn(Plazy({Pseq(freqloop,1)}),inf),						Pfunc { ~lastFrequencyMono }
							).collect { |freqs| ~lastFrequencyMono = freqs },
							\mode, Pif(Pfunc{~adMono} < -39,  Pn(Plazy({Pseq(modeloop,1)}),inf),Pfunc { ~lastModeMono }
							).collect { |modes| ~lastModeMono = modes }
							)
						}
					);
				}
				);
		});
	});

//[LFO RATE START TO TARGET RANDOM RANGE//TARGET SUSTAIN RANDOM RANGE//TARGET TO END//RANDOM RANGE//SUSTAIN VOLUME
~lfo1Params = ({arg a;
		~lfo1Val = a;
		~lfo1Set.value;});
~lfo2Params = ({arg a;
		~lfo2Val = a;
		~lfo2Set.value;});
~lfo3Params = ({arg a;
		~lfo3Val = a;
		~lfo3Set.value;});
~lfo4Params = ({arg a;
		~lfo4Val = a;
		~lfo4Set.value;});
	~lfoMasterParams = ({arg b=[[1,1,1,1,1,1],0, \lin];
		~lfo1Params.value(b);
		~lfo2Params.value(b);
		~lfo3Params.value(b);
		~lfo4Params.value(b);
});

~lfo1Set=({
		var a; var c; var d; var e;
		var f = ~lfo1Val[1];
		var g = ~lfo1Val[2];
		if (~lfo1Val[0].size == 3, {~lfo1Val[0]=~lfo1Val[0].dupEach(2)});
			a = ~lfo1Val[0].clump(2);
			c = a[0];
			d = a[1];
			e = a[2];
		~lfo1Pat = Pbindef(\lfo1,
			\voice,0,
			\dur,0.05,
			\destination, ~targetAddress,
			\id, 'lfo1',
			\volume, Pseg([-45, f, f, -45], [Pwhite(c[0], c[1], 1),														Pwhite(d[0],d[1], 1),Pwhite(e[0], e[1], 1)], g, inf).collect({|event|~ad1 = event;}),
			\timingOffset, 0.1,
			\play, ~oscTransmitter
		);
	});
~lfo2Set=({
		var a; var c; var d; var e;
		var f = ~lfo2Val[1];
		var g = ~lfo2Val[2];
		if (~lfo2Val[0].size == 3, {~lfo2Val[0]=~lfo2Val[0].dupEach(2)});
			a = ~lfo2Val[0].clump(2);
			c = a[0];
			d = a[1];
			e = a[2];
		~lfo2Pat = Pbindef(\lfo2,
			\voice,1,
			\dur,0.05,
			\destination, ~targetAddress,
			\id, 'lfo2',
			\volume, Pseg([-45, f, f, -45], [Pwhite(c[0], c[1], 1),														Pwhite(d[0],d[1], 1),Pwhite(e[0], e[1], 1)], g, inf).collect({|event|~ad2 = event;}),
			\timingOffset, 0.1,
			\play, ~oscTransmitter
		);
	});
~lfo3Set=({
		var a; var c; var d; var e;
		var f = ~lfo3Val[1];
		var g = ~lfo3Val[2];
		if (~lfo3Val[0].size == 3, {~lfo3Val[0]=~lfo3Val[0].dupEach(2)});
			a = ~lfo3Val[0].clump(2);
			c = a[0];
			d = a[1];
			e = a[2];
		~lfo3Pat = Pbindef(\lfo3,
			\voice,2,
			\dur,0.05,
			\destination, ~targetAddress,
			\id, 'lfo3',
			\volume, Pseg([-45, f, f, -45], [Pwhite(c[0], c[1], 1),														Pwhite(d[0],d[1], 1),Pwhite(e[0], e[1], 1)],  g, inf).collect({|event|~ad3 = event;}),
			\timingOffset, 0.1,
			\play, ~oscTransmitter
		);
	});
~lfo4Set=({
		var a; var c; var d; var e;
		var f = ~lfo4Val[1];
		var g = ~lfo4Val[2];
		if (~lfo4Val[0].size == 3, {~lfo4Val[0]=~lfo4Val[0].dupEach(2)});
			a = ~lfo4Val[0].clump(2);
			c = a[0];
			d = a[1];
			e = a[2];
		~lfo4Pat = Pbindef(\lfo4,
			\voice,3,
			\dur,0.05,
			\destination, ~targetAddress,
			\id, 'lfo4',
			\volume, Pseg([-45, f, f, -45], [Pwhite(c[0], c[1], 1),														Pwhite(d[0],d[1], 1),Pwhite(e[0], e[1], 1)], g, inf).collect({|event|~ad4 = event;}),
			\timingOffset, 0.1,
			\play, ~oscTransmitter
);
	});

~lfoMasterParams.value;
~envADMasterParams.value;
~tunerMasterParams.value;


~pspawnerInit = Pspawner({ |sp|
		w = sp;
			~lfo1 = w.par(~lfo1Pat); ~lfo2 = w.par(~lfo2Pat); ~lfo3 = w.par(~lfo3Pat); ~lfo4 = w.par(~lfo4Pat);
			w.suspend(~lfo1); w.suspend(~lfo2); w.suspend(~lfo3); w.suspend(~lfo4);

		~envAD1 = w.par(~envAD1Pat); ~envAD2 = w.par(~envAD2Pat); ~envAD3 = w.par(~envAD3Pat); ~envAD4 = w.par(~envAD4Pat); ~envADMono = w.par(~envADMonoPat);
			w.suspend(~envAD1); w.suspend(~envAD2); w.suspend(~envAD3); w.suspend(~envAD4); w.suspend(~envADMono);

			~tuner1 = w.par(~tuner1Pat); ~tuner2 = w.par(~tuner2Pat); ~tuner3 = w.par(~tuner3Pat); ~tuner4 = w.par(~tuner4Pat); ~tunerMono = w.par(~tunerMonoPat);
		w.suspend(~tuner1); w.suspend(~tuner2); w.suspend(~tuner3); w.suspend(~tuner4); w.suspend(~tunerMono);
	}).play;

~mute = ({
		~showplayer.stop;
		~loopnoise.stop; ~loopnoise.reset;
~radioscanner.stop; ~radioscanner.reset;
	~loop1.stop; ~loop1.reset;
	~morningad.stop; ~morningad.reset;
~morningadsolo.stop; ~morningadsolo.reset;
	~morningmorsecodes.stop; ~morningmorsecodes.reset;
		Pspawner({|sp|
		w = sp;
	~envADMasterParams.value([\const,\long,1,1,0,0]);
	w.par(~envAD1);
	w.par(~envAD2);
	w.par(~envAD3);
	w.par(~envAD4);
		w.wait(1);
		w.suspend(~envAD1);	w.suspend(~envAD2);	w.suspend(~envAD3);	w.suspend(~envAD4);
	}).play;
	{~mute.stop;~mute.reset; ~pspawnerInit.stop;}.defer(2);
	});
});
);


o.value;




