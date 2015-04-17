scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:windo(func, args, obj)
	if len(tabpagebuflist()) <= 1
		return call(a:func, a:args, a:obj)
	endif
	let pre_winnr = winnr()

	noautocmd windo call call(a:func, a:args, a:obj)
	
	if pre_winnr == winnr()
		return
	endif
	execute pre_winnr . "wincmd w"
endfunction


function! s:as_windo(base)
	let windo = {}
	let windo.obj = a:base
	for [key, Value] in items(a:base)
		if type(function("tr")) == type(Value)
			execute
\			"function! windo.". key. "(...)\n"
\			"	return s:windo(self.obj." . key . ", a:000, self.obj)\n"
\			"endfunction"
		endif
		unlet Value
	endfor
	return windo
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
