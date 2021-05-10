let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/goo2-the_gooening/dragonruby-linux-amd64/mygame
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +17 app/main.rb
badd +1 app/init.rb
badd +100 ~/.config/nvim/init.vim
badd +23 app/init_anims.rb
badd +1 app/init_hero.rb
badd +15 app/init_baddie.rb
badd +45 app/init_spells.rb
badd +18 a.rb
badd +1 term://.//23273:tail\ -f\ /dev/null;\#gdb\ program
badd +5 term://.//23275:/usr/bin/gdb
badd +1 sprites/siegetrooper-attack-5.png
badd +1 app/init_siegeguy.rb
badd +1 app/anim.rb
badd +1 app/init_steelclad.rb
badd +6 README.md
badd +1 init\ anim
badd +1 app/init_mage.rb
badd +43 TODO.md
badd +25 app/mage_factory.rb
badd +46 app/steelclad_factory.rb
badd +1 app/components.rb
badd +33 app/animation.rb
badd +1 app/factory_template.rb
badd +16 app/tools.rb
badd +31 app/spell_factory.rb
badd +68 app/init/init.rb
badd +1 app/init/init_anims.rb
badd +1 sprites/misc/tiny-star.png
badd +30 app/systems/behavior.rb
badd +1 app/systems/animation.rb
badd +2 app/factories/steelclad_factory.rb
badd +1 app/factories/mage_factory.rb
badd +29 app/factories/factory_template.rb
badd +36 app/factories/spell_factory.rb
badd +1 app/tests/tests.rb
argglobal
%argdel
set stal=2
edit app/init/init_anims.rb
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 119 + 119) / 238)
exe 'vert 2resize ' . ((&columns * 118 + 119) / 238)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 021|
wincmd w
argglobal
if bufexists("app/init/init.rb") | buffer app/init/init.rb | else | edit app/init/init.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 68 - ((45 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
68
normal! 016|
wincmd w
exe 'vert 1resize ' . ((&columns * 119 + 119) / 238)
exe 'vert 2resize ' . ((&columns * 118 + 119) / 238)
tabedit app/components.rb
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 119 + 119) / 238)
exe 'vert 2resize ' . ((&columns * 118 + 119) / 238)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 39 - ((38 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
39
normal! 020|
wincmd w
argglobal
if bufexists("app/systems/animation.rb") | buffer app/systems/animation.rb | else | edit app/systems/animation.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 6 - ((5 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
6
normal! 0
wincmd w
exe 'vert 1resize ' . ((&columns * 119 + 119) / 238)
exe 'vert 2resize ' . ((&columns * 118 + 119) / 238)
tabnext 1
set stal=1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOF
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
