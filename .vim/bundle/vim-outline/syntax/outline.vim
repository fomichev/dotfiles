if exists("b:current_syntax")
	finish
endif

setlocal foldmethod=syntax
setlocal foldnestmax=99

syn keyword OrgTodo TODO contained
syn keyword OrgDone DONE contained
syn cluster OrgTask contains=OrgTodo,OrgDone

syn match OrgTag /:\zs[^:]*\ze:/

syn match OrgScheduled /SCHEDULED:/
syn match OrgDeadline /DEADLINE:/
syn match OrgDate /<[^>]*>/

syn cluster OrgInline contains=@OrgTask,OrgTag,OrgDate,OrgScheduled,OrgDeadline

syn match OrgOutline1Header '^\*[^*].*$' contained contains=@OrgInline
syn match OrgOutline2Header '^\*\{2\}[^*].*$' contained contains=@OrgInline
syn match OrgOutline3Header '^\*\{3\}[^*].*$' contained contains=@OrgInline
syn match OrgOutline4Header '^\*\{4\}[^*].*$' contained contains=@OrgInline


" should be *bold*
syn region OrgBold start="/" end="/" contained
syn region OrgItalic start="/" end="/" contained
syn region OrgCode start="=" end="=" contained
syn region OrgVerbatim start="\~" end="\~" contained
syn region OrgUnderlined start="_" end="_" contained
syn region OrgStriked start="+" end="+" contained

syn match OrgUListPlus "^\s*\zs+\ze.*$" contained
syn match OrgUListMinus "^\s*\zs-\ze.*$" contained
syn match OrgUListStar "^\s\+\zs\*\ze.*$" contained
syn cluster OrgUList contains=OrgUListPlus,OrgUListMinus,OrgUListStar

syn match OrgOListDot "^\s*\zs\d\+\.\ze.*$" contained
syn match OrgOListBrace "^\s*\zs\d\+)\ze.*$" contained
syn cluster OrgOList contains=OrgOListDot,OrgOListBrace

syn match OrgCheckboxEmpty "^\s*\zs- \[ \]\ze.*$" contained
syn match OrgCheckboxSet "^\s*\zs- \[X\]\ze.*$" contained
syn cluster OrgCheckbox contains=OrgCheckboxEmpty,OrgCheckboxSet

" DOESNT WORK:
syn region OrgTableRow start="|" end="|" contained
syn cluster OrgTable contains=OrgTableRow


syn cluster OrgInBody contains=OrgBold,OrgItalic,OrgCode,OrgVerbatim,OrgUnderlined,OrgStriked,@OrgUList,@OrgOList,@OrgCheckbox,@OrgTable
" | xxx | bbb |
"OrgTable

syn region OrgOutline1 matchgroup=NONE
			\ start='^\*[^*].*$'
			\ end='\(\n\ze\*[^*]\)\|\(\%$\)'
			\ fold keepend
			\ transparent
			\ contains=OrgOutline1Header,OrgOutline2,@OrgInline,@OrgInBody

syn region OrgOutline2 matchgroup=NONE
			\ start='^\*\{2\}[^*].*$'
			\ end='\(\n\ze\*\{1,2\}[^*]\)\|\(\%$\)'
			\ fold keepend
			\ transparent
			\ contains=OrgOutline2Header,OrgOutline3,@OrgInline,@OrgInBody

syn region OrgOutline3 matchgroup=OrgOutline3Header
			\ start='^\*\{3\}[^*].*$'
			\ end='\(\n\ze\*\{1,3\}[^*]\)\|\(\%$\)'
			\ fold keepend
			\ transparent
			\ contains=OrgOutline3Header,OrgOutline4,@OrgInline,@OrgInBody

syn region OrgOutline4 matchgroup=OrgOutline4Header
			\ start='^\*\{4\}[^*].*$'
			\ end='\(\n\ze\*\{1,4\}[^*]\)\|\(\%$\)'
			\ fold keepend
			\ transparent
			\ contains=OrgOutline4Header,@OrgInline,@OrgInBody


hi! default link OrgOutline1Header Identifier
hi! default link OrgOutline2Header Constant
hi! default link OrgOutline3Header Type
hi! default link OrgOutline4Header Statement

hi! default link OrgTodo Todo
hi! default link OrgDone Todo

hi! default link OrgTag Label
hi! default link OrgDate Special

hi! default link OrgBold ErrorMsg
hi! default link OrgItalic ErrorMsg
hi! default link OrgCode ErrorMsg
hi! default link OrgVerbatim ErrorMsg
hi! default link OrgUnderlined ErrorMsg
hi! default link OrgStriked ErrorMsg

hi! default link OrgScheduled Keyword
hi! default link OrgDeadline Error

hi! default link OrgUListPlus Error
hi! default link OrgUListMinus Error
hi! default link OrgUListStar Error

hi! default link OrgOListDot Error
hi! default link OrgOListBrace Error

hi! default link OrgCheckboxEmpty Error
hi! default link OrgCheckboxSet Error

hi! default link OrgTableRow Error

syn sync fromstart

let b:current_syntax = "outline"
