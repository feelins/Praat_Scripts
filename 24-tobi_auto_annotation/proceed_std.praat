procedure intervalInfo: tier, pos
	check_type = Is interval tier: tier
	if check_type == 1
		start = Get starting point: tier, pos
		end = Get end point: tier, pos
		dur = end - start
		dur$ = fixed$ (dur, 2)
		lab$ = Get label of interval: tier, pos
	else
		start = Get time of point: tier, pos
		lab$ = Get label of point: tier, pos
	endif
endproc


####
procedure featExtraction: feat$
	if feat$ == "pitch"
		meanf0 = Get mean: start, end, "Hertz"
		maxf0 = Get maximum: start, end, "Hertz", "Parabolic"
		minf0 = Get minimum: start, end, "Hertz", "Parabolic"
		t_maxf0 = Get time of maximum: start, end, "Hertz", "Parabolic"
		t_relMax = (t_maxf0-start) / (end-start)
		stdf0 = Get standard deviation: start, end, "Hertz"
		f0_pph = Get mean: start_pph, end_pph, "Hertz"
		stdf0_pph = Get standard deviation: start_pph, end_pph, "Hertz"
		t_minf0 = Get time of minimum: start, end, "Hertz", "Parabolic"
		rangeF0 = maxf0 - minf0
		z_f0 = (meanf0 - f0_pph) / stdf0_pph
		z_f0$ = fixed$ (z_f0, 2)
		t_relMax$ = fixed$ (t_relMax, 2)
		rangeF0$ = fixed$ (rangeF0, 0)
	elif feat$ == "int"
		min = Get minimum: start, end, "Parabolic"
		t_min = Get time of minimum: start, end, "Parabolic"
		t_relMin = (t_min-start)/ (end-start)
		t_relMin$ = fixed$ (t_relMin, 2)

		mean = Get mean: start, end, "dB"
		std = Get standard deviation: start, end
		int_pph = Get mean: start_pph, end_pph, "dB"
		stdint_pph = Get standard deviation: start_pph, end_pph

		# Calculate z-scores 
		z_int = (mean - int_pph) / stdint_pph
		z_int$ = fixed$ (z_int, 2)
	endif
endproc
