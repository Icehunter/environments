hi clear

set background=dark

if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name="icehunter"

" Helper Functions:
" Returns an approximate grey index for the given grey level
function! s:grey_number(x)
  if &t_Co == 88
    if a:x < 23
      return 0
    elseif a:x < 69
      return 1
    elseif a:x < 103
      return 2
    elseif a:x < 127
      return 3
    elseif a:x < 150
      return 4
    elseif a:x < 173
      return 5
    elseif a:x < 196
      return 6
    elseif a:x < 219
      return 7
    elseif a:x < 243
      return 8
    else
      return 9
    endif
  else
    if a:x < 14
      return 0
    else
      let l:n = (a:x - 8) / 10
      let l:m = (a:x - 8) % 10
      if l:m < 5
        return l:n
      else
        return l:n + 1
      endif
    endif
  endif
endfunction

" Returns the actual grey level represented by the grey index
function! s:grey_level(n)
  if &t_Co == 88
    if a:n == 0
      return 0
    elseif a:n == 1
      return 46
    elseif a:n == 2
      return 92
    elseif a:n == 3
      return 115
    elseif a:n == 4
      return 139
    elseif a:n == 5
      return 162
    elseif a:n == 6
      return 185
    elseif a:n == 7
      return 208
    elseif a:n == 8
      return 231
    else
      return 255
    endif
  else
    if a:n == 0
      return 0
    else
      return 8 + (a:n * 10)
    endif
  endif
endfunction

" Returns the palette index for the given grey index
function! s:grey_colour(n)
  if &t_Co == 88
    if a:n == 0
      return 16
    elseif a:n == 9
      return 79
    else
      return 79 + a:n
    endif
  else
    if a:n == 0
      return 16
    elseif a:n == 25
      return 231
    else
      return 231 + a:n
    endif
  endif
endfunction

" Returns an approximate colour index for the given colour level
function! s:rgb_number(x)
  if &t_Co == 88
    if a:x < 69
      return 0
    elseif a:x < 172
      return 1
    elseif a:x < 230
      return 2
    else
      return 3
    endif
  else
    if a:x < 75
      return 0
    else
      let l:n = (a:x - 55) / 40
      let l:m = (a:x - 55) % 40
      if l:m < 20
        return l:n
      else
        return l:n + 1
      endif
    endif
  endif
endfunction

" Returns the actual colour level for the given colour index
function! s:rgb_level(n)
  if &t_Co == 88
    if a:n == 0
      return 0
    elseif a:n == 1
      return 139
    elseif a:n == 2
      return 205
    else
      return 255
    endif
  else
    if a:n == 0
      return 0
    else
      return 55 + (a:n * 40)
    endif
  endif
endfunction

" Returns the palette index for the given R/G/B colour indices
function! s:rgb_colour(x, y, z)
  if &t_Co == 88
    return 16 + (a:x * 16) + (a:y * 4) + a:z
  else
    return 16 + (a:x * 36) + (a:y * 6) + a:z
  endif
endfunction

" Returns the palette index to approximate the given R/G/B colour levels
function! s:colour(r, g, b)
  " Get the closest grey
  let l:gx = s:grey_number(a:r)
  let l:gy = s:grey_number(a:g)
  let l:gz = s:grey_number(a:b)

  " Get the closest colour
  let l:x = s:rgb_number(a:r)
  let l:y = s:rgb_number(a:g)
  let l:z = s:rgb_number(a:b)

  if l:gx == l:gy && l:gy == l:gz
    " There are two possibilities
    let l:dgr = s:grey_level(l:gx) - a:r
    let l:dgg = s:grey_level(l:gy) - a:g
    let l:dgb = s:grey_level(l:gz) - a:b
    let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
    let l:dr = s:rgb_level(l:gx) - a:r
    let l:dg = s:rgb_level(l:gy) - a:g
    let l:db = s:rgb_level(l:gz) - a:b
    let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
    if l:dgrey < l:drgb
      " Use the grey
      return s:grey_colour(l:gx)
    else
      " Use the colour
      return s:rgb_colour(l:x, l:y, l:z)
    endif
  else
    " Only one possibility
    return s:rgb_colour(l:x, l:y, l:z)
  endif
endfunction

" Returns the palette index to approximate the '#rrggbb' hex string
function! s:rgb(rgb)
  let l:r = ("0x" . strpart(a:rgb, 1, 2)) + 0
  let l:g = ("0x" . strpart(a:rgb, 3, 2)) + 0
  let l:b = ("0x" . strpart(a:rgb, 5, 2)) + 0

  return s:colour(l:r, l:g, l:b)
endfunction

" Sets the highlighting for the given group
function! s:HL(group, fg, bg, attr)
  if !empty(a:fg)
    exec "hi " . a:group . " ctermfg=" . s:rgb(a:fg)
  endif
  if !empty(a:bg)
    exec "hi " . a:group . " ctermbg=" . s:rgb(a:bg)
  endif
  if a:attr != ""
    exec "hi " . a:group . " cterm=" . a:attr
  endif
endfunction

" Color Palette:
" These color names are corresponding to the original light version,
" and they don't represent the HEX code that they store in this block.
let s:amber         = '#ffc107'
let s:black         = '#000000'
let s:blue          = '#2196f3'
let s:bluegrey      = '#607d8b'
let s:brown         = '#795548'
let s:cyan          = '#00bcd4'
let s:darkgrey      = '#606060'
let s:deeporange    = '#ff5722'
let s:deeppurple    = '#673ab7'
let s:green         = '#4caf50'
let s:grey          = '#808080'
let s:indigo        = '#3f51b5'
let s:lightblue     = '#03a9f4'
let s:lightgreen    = '#8bc34a'
let s:lightgrey     = '#c0c0c0'
let s:lime          = '#cddc39'
let s:orange        = '#ff9800'
let s:pink          = '#e91e63'
let s:purple        = '#9c27b0'
let s:red           = '#f44336'
let s:teal          = '#009688'
let s:teal300       = '#4db6ac'
let s:verydarkgrey  = '#1a1a1a'
let s:verylightgrey = '#e0e0e0'
let s:yellow        = '#ffeb3b'
let s:white         = '#FFFFFF'

" Vim Highlighting
call s:HL("Boolean", s:green, "", "bold")
call s:HL("BufTabLineActive", "", "", "None")
call s:HL("BufTabLineCurrent", "", "", "None")
call s:HL("BufTabLineFill", "", "", "None")
call s:HL("BufTabLineHidden", "", "", "None")
call s:HL("Character", s:lightgreen, "", "")
call s:HL("ColorColumn", "", s:yellow, "none")
call s:HL("Comment", s:darkgrey, "", "")
call s:HL("Conditional", s:purple, "", "bold")
call s:HL("Constant", s:orange, "", "")
call s:HL("Cursor", "", "", "none")
call s:HL("CursorColumn", "", s:darkgrey, "none")
call s:HL("CursorLine", "", s:verydarkgrey, "underline")
call s:HL("CursorLineNr", s:amber, "", "bold")
call s:HL("Debug", s:orange, "", "")
call s:HL("Define", s:blue, "", "")
call s:HL("Delimiter", "", "", "")
call s:HL("DiffAdd", "", "", "")
call s:HL("DiffChange", "", "", "")
call s:HL("DiffDelete", "", "", "")
call s:HL("DiffText", "", "", "")
call s:HL("Directory", s:blue, "", "")
call s:HL("Error", s:white, s:red, "")
call s:HL("Exception", s:red, "", "")
call s:HL("Float", s:orange, "", "")
call s:HL("FoldColumn", "", s:black, "")
call s:HL("Folded", "", "", "")
call s:HL("Function", s:white, "", "")
call s:HL("Global", s:blue, "", "")
call s:HL("Identifier", s:indigo, "", "")
call s:HL("Ignore", s:darkgrey, "", "")
call s:HL("Include", s:red, "", "")
call s:HL("Keyword", s:blue, "", "")
call s:HL("Label", s:blue, "", "")
call s:HL("LineNr", s:darkgrey, "", "")
call s:HL("Macro", s:blue, "", "")
call s:HL("MatchParen", "", "", "")
call s:HL("ModeMsg", s:lightgreen, "", "")
call s:HL("MoreMsg", s:lightgreen, "", "")
call s:HL("NonText", "", "", "")
call s:HL("Normal", s:white, s:black, "")
call s:HL("Number", s:orange, "", "")
call s:HL("Operator", s:lightblue, "", "none")
call s:HL("PMenu", s:white, s:deeporange, "none")
call s:HL("PMenuSbar", s:lightblue, "", "")
call s:HL("PMenuSel", s:white, s:deeporange, "reverse")
call s:HL("PMenuThumb", s:lightblue, "", "")
call s:HL("PreCondit", s:lightblue, "", "")
call s:HL("PreProc", s:blue, "", "")
call s:HL("Question", s:lightgreen, "", "")
call s:HL("Repeat", s:purple, "", "bold")
call s:HL("Search", "", "", "")
call s:HL("SignColumn", s:green, s:black, "none")
call s:HL("Special", s:white, "", "")
call s:HL("SpecialChar", s:white, "", "")
call s:HL("SpecialComment", s:darkgrey, "", "bold")
call s:HL("SpecialKey", "", "", "")
call s:HL("Statement", s:pink, "", "none")
call s:HL("StatusLine", "", "", "bold")
call s:HL("StatusLineNC", "", "", "None")
call s:HL("StorageClass", s:indigo, "", "bold")
call s:HL("String", s:lightgreen, "", "")
call s:HL("Structure", s:blue, "", "bold")
call s:HL("TabLine", "", "", "None")
call s:HL("TabLineFill", "", "", "None")
call s:HL("TabLineSel", "", "", "None")
call s:HL("Tag", s:green, "", "")
call s:HL("Title", s:darkgrey, "", "")
call s:HL("Todo", s:lightblue, s:black, "bold")
call s:HL("Type", s:pink, "", "bold")
call s:HL("Typedef", s:pink, "", "bold")
call s:HL("Underlined", s:pink, "", "underline")
call s:HL("VertSplit", s:teal, s:black, "none")
call s:HL("Visual", "", "", "")
call s:HL("VisualNOS", "", "", "")
call s:HL("WarningMsg", s:pink, "", "")
call s:HL("WildMenu", "", "", "bold")

" JavaScript Highlighting
call s:HL("javaScriptBoolean", s:green, "", "bold")
call s:HL("javaScriptBraces", s:blue, "", "")
call s:HL("javaScriptConditional", s:purple, "", "bold")
call s:HL("javaScriptFunction", s:blue, "", "bold")
call s:HL("javascriptGlobal", s:white, "", "")
call s:HL("javaScriptIdentifier", s:pink, "", "")
call s:HL("javaScriptMember", s:white, "", "")
call s:HL("javaScriptMember", s:indigo, "", "")
call s:HL("javaScriptMessage", s:white, "", "")
call s:HL("javascriptNull", s:darkgrey, "", "bold")
call s:HL("javaScriptNumber", s:orange, "", "")
call s:HL("javaScriptParens", s:blue, "", "")
call s:HL("javaScriptRepeat", s:purple, "", "bold")
call s:HL("javaScriptReserved", s:indigo, "", "")
call s:HL("javascriptStatement", s:pink, "", "")
call s:HL("jsBraces", s:blue, "", "")
call s:HL("jsFuncBraces", s:blue, "", "")
call s:HL("jsFuncParens", s:blue, "", "")
call s:HL("jsNoise", s:blue, "", "")
call s:HL("jsParens", s:blue, "", "")

" Json Highlighting
call s:HL("jsonBoolean", s:green, "", "bold")
call s:HL("jsonBraces", s:white, "", "")
call s:HL("jsonCommentError", s:pink, s:black , "")
call s:HL("jsonKeyword", s:blue, "", "")
call s:HL("jsonKeywordMatch", s:white, "", "")
call s:HL("jsonNoise", s:white, "", "")
call s:HL("jsonNull", s:purple, "", "bold")
call s:HL("jsonNumber", s:orange, "", "")
call s:HL("jsonQuote", s:darkgrey, "", "")
call s:HL("jsonString", s:lightgreen, "", "")
