# vim-SaveLoadMapping

Save or load a key mapping.

## Usage

```vimL
:SaveMapping {lhs}[, {mode}]
:LoadMapping {lhs}[, {mode}[, {buffer}]]
```

- `{lhs}` is the left-hand side of a mapping.
- `{mode}` is the map mode, same as `:help maparg()` describes. When omitted, `''` is used.
- `{buffer}` is a buffer number for a local mapping or the string `'global'` for
a global mapping. When omitted, the current buffer number `bufnr('%')` and
`'global'` are tried to use successively.

String arguments should be enclosed in single or double quotes. 
