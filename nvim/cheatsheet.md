# Neovim Cheatsheet

> Leader key: `Space` | Local leader: `\`

---

## File Explorer (nvim-tree)

| Shortcut | Action |
|---|---|
| `<leader>e` | Toggle file explorer |

---

## Fuzzy Finder (Telescope)

| Shortcut | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help tags |

---

## LSP

| Shortcut | Action |
|---|---|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

> Active for: Python (pyright), C (clangd), Lua (lua_ls), Bash (bashls)

---

## Autocompletion (nvim-cmp)

| Shortcut | Action |
|---|---|
| `<C-Space>` | Trigger completion menu |
| `<CR>` | Confirm selected item |
| `<Tab>` | Next item / expand snippet / jump snippet |

---

## Terminal (toggleterm)

| Shortcut | Action |
|---|---|
| `<leader>t` | Toggle horizontal terminal |

---

## Dashboard (alpha-nvim)

| Key | Action |
|---|---|
| `f` | Find file |
| `g` | Live grep |
| `r` | Recent files |
| `e` | File explorer |
| `c` | Open config (init.lua) |
| `q` | Quit |

---

## Surround (nvim-surround)

| Shortcut | Action |
|---|---|
| `ys{motion}{char}` | Add surround — e.g. `ysiw"` wraps word in `"` |
| `ds{char}` | Delete surround — e.g. `ds"` removes `"` |
| `cs{old}{new}` | Change surround — e.g. `cs"'` changes `"` to `'` |

---

## Comments (Comment.nvim)

| Shortcut | Action |
|---|---|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc{motion}` | Comment motion — e.g. `gcap` comments a paragraph |

---

## Git (gitsigns)

| Shortcut | Action |
|---|---|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

---

## General Vim — Navigation

| Shortcut | Action |
|---|---|
| `gg` | Go to top of file |
| `G` | Go to bottom of file |
| `{n}G` | Go to line n |
| `Ctrl-d` | Scroll down half page |
| `Ctrl-u` | Scroll up half page |
| `zz` | Center cursor on screen |
| `%` | Jump to matching bracket |

---

## General Vim — Editing

| Shortcut | Action |
|---|---|
| `u` | Undo |
| `Ctrl-r` | Redo |
| `ciw` | Change inner word |
| `diw` | Delete inner word |
| `yiw` | Yank inner word |
| `dd` | Delete line |
| `yy` | Yank line |
| `p` | Paste after |
| `P` | Paste before |
| `>>` / `<<` | Indent / unindent line |
| `=G` | Auto-indent to end of file |

---

## General Vim — Windows & Buffers

| Shortcut | Action |
|---|---|
| `Ctrl-w v` | Split vertical |
| `Ctrl-w s` | Split horizontal |
| `Ctrl-w h/j/k/l` | Navigate splits |
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Close buffer |

---

## Formatting (conform.nvim)

Formatting runs automatically on save for:

| Language | Formatter |
|---|---|
| Python | `black` |
| C | `clang_format` |
| Lua | `stylua` |

---

## Misc

| Shortcut | Action |
|---|---|
| `<leader>?` | Show all keybindings (which-key) |
