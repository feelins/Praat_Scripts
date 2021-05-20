procedure writeFeat: tier, pos, text$, val$
	check_type = Is interval tier: tier
	if check_type == 1
		head$ = Get label of interval: tier, pos
		if head$ != ""
			final_text$ = '@{@"' + text$ + '"="' + val$ + '"@}@'
			Set interval text: tier, pos, final_text$
		else
			final_text$ = head$ + '@{@"' + text$ + '"="' + val$ + '"@}@'
			Set interval text: tier, pos, final_text$
		endif
	else
		head = Get label of point: tier, pos
		check_feat = head[:-1]
		final_text = 
		Set point text: tier, pos, final_text
	endif
endproc
