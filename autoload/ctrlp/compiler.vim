if exists('g:loaded_ctrlp_compiler')
    finish
endif
let g:loaded_ctrlp_compiler = 1

let s:compiler_var = {
	\ 'init': 'ctrlp#compiler#init()',
	\ 'accept': 'ctrlp#cmdline#accept',
	\ 'lname': 'compiler',
	\ 'sname': 'compiler',
	\ 'type': 'line',
	\ 'sort': 0,
	\ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:compiler_var)
else
	let g:ctrlp_ext_vars = [s:compiler_var]
endif

function! ctrlp#compiler#get_compilers()
	let compilers_blob
	redir => compilers_blob
	:compiler
	redir END
	let compilers = split(compilers, '\r')
	call map(ctrlp#compiler#extract_compiler_string_from_compiler_path, compilers)
	return compilers
endfun

function! ctrlp#compiler#extract_compiler_string_from_compiler_path(path)
	let extracted = fnamemodify(path, ':t:r')
	if empty(extracted)
		throw 'ctrlp-compiler internal error: no compiler recognized into ``"' . path .'"'
	endif
endfun

function! ctrlp#compiler#init()
	let compilers = ctrlp#compiler#get_compilers()
	return compilers
endfunction

function! ctrlp#compiler#accept(compiler)
	exec ':compiler ' . compiler
	echom 'Set compiler to ' . compiler
endfun


