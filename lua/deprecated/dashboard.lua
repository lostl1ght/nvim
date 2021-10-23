local g = vim.g
--[[
g.dashboard_custom_header = {
"      .            .      ",
"    .,;'           :,.    ",
"  .,;;;,,.         ccc;.  ",
".;c::::,,,'        ccccc: ",
".::cc::,,,,,.      cccccc.",
".cccccc;;;;;;'     llllll.",
".cccccc.,;;;;;;.   llllll.",
".cccccc  ';;;;;;'  oooooo.",
"'lllllc   .;;;;;;;.oooooo'",
"'lllllc     ,::::::looooo'",
"'llllll      .:::::lloddd'",
".looool       .;::coooodo.",
"  .cool         'ccoooc.  ",
"    .co          .:o:.    ",
"      .           .'      ",
}
--]]
g.dashboard_custom_header = {
'                   -`                 ',
'                  .o+`                ',
'                 `ooo/                ',
'                `+oooo:               ',
'               `+oooooo:              ',
'               -+oooooo+:             ',
'             `/:-:++oooo+:            ',
'            `/++++/+++++++:           ',
'           `/++++++++++++++:          ',
'          `/+++ooooooooooooo/`        ',
'         ./ooosssso++osssssso+`       ',
'        .oossssso-````/ossssss+`      ',
'       -osssssso.      :ssssssso.     ',
'      :osssssss/        osssso+++.    ',
'     /ossssssss/        +ssssooo/-    ',
'   `/ossssso+/:-        -:/+osssso+-  ',
'  `+sso+:-`                 `.-/+oso: ',
' `++:.                           `-/+/',
' .`                                 `/',
}
g.dashboard_custom_section = {
    a = {
        description = {' Last session      SPC s l'},
        command = 'LoadSession',
    },
    b = {
        description = {' Open file         SPC f f'},
        command = 'lua require("telescope.builtin").find_files()',
    },
    c = {
        description = {'ﭯ Recent files      SPC f r'},
        command = 'lua require("telescope.builtin").oldfiles()',
    },
    d = {
        description = {' New file          SPC f n'},
        command = 'enew',
    },
    e = {
        description = {'⌀ Load session      SPC s s'},
        command = 'Telescope sessions',
    },
    f = {
        description = {' Find word         SPC f w'},
        command = 'lua require("telescope.builtin").live_grep()',
    },
}
