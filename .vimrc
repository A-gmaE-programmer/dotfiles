if (has("termguicolors"))
	set termguicolors
endif

"My attempt at a function to automatically expand curly braces
autocmd FileType * inoremap <expr> <CR> BeforeBraces() ? "<CR><Esc>O" : "<CR>"
function! BeforeBraces()
	let after_char = getline('.')[col('.') - 1]
	let before_char = getline('.')[col('.') - 2]
	return (before_char == '{' && after_char == '}')
endfunction

"Show line numbers
set number
set shiftwidth=4 smarttab
set tabstop=8 softtabstop=0

"Macro to tab out of brackets
autocmd FileType * inoremap <expr> <tab> MultiTab()
function! MultiTab()
	let check_char = getline('.')[col('.') - 1]
	if check_char == ')'
		return "\<c-o>a"
	elseif check_char == ']'
		return "\<c-o>a"
	elseif check_char == '}'
		return "\<c-o>a"
	elseif check_char == '"'
		return "\<c-o>a"
	elseif check_char == "'"
		return "\<c-o>a"
	elseif check_char == '>'
		return "\<c-o>a"
	else
		return "\<tab>"
	endif
endfunction

autocmd FileType .html let g:AutoClosePairs_add = "<>"
