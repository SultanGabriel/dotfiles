local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
[[         .m.                                   ,_		]],
[[         ' ;M;                                ,;m `		]],
[[           ;M;.           ,      ,           ;SMM;		]],
[[          ;;Mm;         ,;  ____  ;,         ;SMM;		]],
[[         ;;;MM;        ; (.MMMMMM.) ;       ,SSMM;;		]],
[[       ,;;;mMp'        l  ';mmmm;/  j       SSSMM;;		]],
[[     .;;;;;MM;         .\,.mmSSSm,,/,      ,SSSMM;;;		]],
[[    ;;;;;;mMM;        .;MMmSSSSSSSmMm;     ;MSSMM;;;;		]],
[[   ;;;;;;mMSM;     ,_ ;MMmS;;;;;;mmmM;  -,;MMMMMMm;;;;		]],
[[  ;;;;;;;MMSMM;     \"*;M;( ( '') );m;*"/ ;MMMMMM;;;;;,		]],
[[ .;;;;;;mMMSMM;      \(@;! _     _ !;@)/ ;MMMMMMMM;;;;;,		]],
[[ ;;;;;;;MMSSSM;       ;,;.*o*> <*o*.;m; ;MMMMMMMMM;;;;;;,		]],
[[.;;;;;;;MMSSSMM;     ;Mm;           ;M;,MMMMMMMMMMm;;;;;;.		]],
[[;;;;;;;mmMSSSMMMM,   ;Mm;,   '-    ,;M;MMMMMMMSMMMMm;;;;;;;		]],
[[;;;;;;;MMMSSSMMMMMMMm;Mm;;,  ___  ,;SmM;MMMMMMSSMMMM;;;;;;;;		]],
[[;;'";;;MMMSSSSMMMMMM;MMmS;;,  "  ,;SmMM;MMMMMMSSMMMM;;;;;;;;.		]],
[[!   ;;;MMMSSSSSMMMMM;MMMmSS;;._.;;SSmMM;MMMMMMSSMMMM;;;;;;;;;		]],
[[    ;;;;*MSSSSSSMMMP;Mm*"'q;'   `;p*"*M;MMMMMSSSSMMM;;;;;;;;;		]],
[[    ';;;  ;SS*SSM*M;M;'     `-.        ;;MMMMSSSSSMM;;;;;;;;;,		]],
[[     ;;;. ;P  `q; qMM.                 ';MMMMSSSSSMp' ';;;;;;;		]],
[[     ;;;; ',    ; .mm!     \.   `.   /  ;MMM' `qSS'    ';;;;;;		]],
[[     ';;;       ' mmS';     ;     ,  `. ;'M'   `S       ';;;;;		]],
[[      `;;.        mS;;`;    ;     ;    ;M,!     '  luk   ';;;;		]],
[[       ';;       .mS;;, ;   '. o  ;   oMM;                ;;;;		]],
[[        ';;      MMmS;; `,   ;._.' -_.'MM;                 ;;;		]],
[[         `;;     MMmS;;; ;   ;      ;  MM;                 ;;;		]],
[[           `'.   'MMmS;; `;) ',    .' ,M;'                 ;;;		]],
[[              \    '' ''; ;   ;    ;  ;'                   ;;		]],
[[               ;        ; `,  ;    ;  ;                   ;;		]],
[[                        |. ;  ; (. ;  ;      _.-.         ;;		]],
[[           .-----..__  /   ;  ;   ;' ;\  _.-" .- `.      ;;		]],
[[         ;' ___      `*;   `; ';  ;  ; ;'  .-'    :      ;		]],
[[         ;     """*-.   `.  ;  ;  ;  ; ' ,'      /       |		]],
[[         ',          `-_    (.--',`--'..'      .'        ',		]],
[[           `-_          `*-._'.\\\;||\\)     ,'		]],
[[              `"*-._        "*`-ll_ll'l    ,'		]],
[[                 ,==;*-._           "-.  .'		]],
[[              _-'    "*-=`*;-._        ;'		]],
[[            ."            ;'  ;"*-.    `		]],
[[            ;   ____      ;//'     "-   `,		]],
[[            `+   .-/                 ".\\;		]],
[[              `*" /                    "'		]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}


vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimStarted",
	callback = function()
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
		pcall(vim.cmd.AlphaRedraw)
	end,
})

-- local function footer()
-- 	local stats = require("lazy").stats()
-- 	local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

-- 	local footer_text = "Startup time " .. ms
-- 	return footer_text
-- end

-- dashboard.section.footer.val = footer()

-- dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
