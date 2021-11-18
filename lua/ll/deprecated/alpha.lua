local present, alpha = pcall(require, 'alpha')
if not present then
    return print('alpha not found')
end

local dashboard = require('alpha.themes.dashboard')

dashboard.section.buttons.val = {
    dashboard.button('SPC k l', '  Last session', ':LoadLastSession<cr>'),
    dashboard.button('SPC k o', '⌀  Load session', ':Telescope sessions<cr>'),
    dashboard.button('SPC f f', '  Open file', ':Telescope find_files<cr>'),
    dashboard.button('SPC f r', 'ﭯ  Recent files', ':Telescope oldfiles<cr>'),
    dashboard.button('SPC b n', '  New file', ':enew<cr>'),
    dashboard.button('SPC f w', '  Find word', ':Telescope live_grep<cr>'),
    dashboard.button('q', '  Quit', ':qa<cr>'),
}

dashboard.section.footer.val = require('ll.util.quotes').get_quote()
alpha.setup(dashboard.opts)

local neovim = {
    '      .            .      ',
    "    .,;'           :,.    ",
    '  .,;;;,,.         ccc;.  ',
    ".;c::::,,,'        ccccc: ",
    '.::cc::,,,,,.      cccccc.',
    ".cccccc;;;;;;'     llllll.",
    '.cccccc.,;;;;;;.   llllll.',
    ".cccccc  ';;;;;;'  oooooo.",
    "'lllllc   .;;;;;;;.oooooo'",
    "'lllllc     ,::::::looooo'",
    "'llllll      .:::::lloddd'",
    '.looool       .;::coooodo.',
    "  .cool         'ccoooc.  ",
    '    .co          .:o:.    ',
    "      .           .'      ",
}

local arch = {
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

local manjaro = {
    '██████████████████  ████████',
    '██████████████████  ████████',
    '██████████████████  ████████',
    '██████████████████  ████████',
    '████████            ████████',
    '████████  ████████  ████████',
    '████████  ████████  ████████',
    '████████  ████████  ████████',
    '████████  ████████  ████████',
    '████████  ████████  ████████',
    '████████  ████████  ████████',
    '████████  ████████  ████████',
    '████████  ████████  ████████',
    '████████  ████████  ████████',
}

dashboard.section.header.val = manjaro
