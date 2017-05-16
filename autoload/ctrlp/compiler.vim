if exists('g:loaded_ctrlp_compiler')
    finish
endif
let g:loaded_ctrlp_compiler = 1

let s:compiler_var = {
	\ 'init': 'ctrlp#compiler#init()',
	\ 'accept': 'ctrlp#compiler#accept',
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
	let l:compilers_blob = ''
	redir => l:compilers_blob
	:silent :compiler
	redir END
	let l:compilers = split(l:compilers_blob, '\n')
	call map(l:compilers, function('ctrlp#compiler#extract_compiler_string_from_compiler_path'))
	return l:compilers
endfun

function! ctrlp#compiler#extract_compiler_string_from_compiler_path(index, path)
	" echom 'Got path: ' . a:path
	let l:extracted = fnamemodify(a:path, ':t:r')
	if empty(l:extracted)
		throw 'ctrlp-compiler internal error: no compiler recognized into ``"' . a:path .'"'
	endif
	" echom 'Extracted: ' . l:extracted
	return l:extracted
endfun

function! ctrlp#compiler#init()
	let l:compilers = ctrlp#compiler#get_compilers()
	return l:compilers
endfunction

function! ctrlp#compiler#accept(mode, compiler)
	exec 'compiler! ' . a:compiler
	make
	call ctrlp#exit()
endfun

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#compiler#id()
	return s:id
endfun

