function inc-search-history
  history merge
  set current (history | fzf --prompt "HISTORY> " -q (commandline -b) \
      --bind="ctrl-d:execute[history delete --case-sensitive --exact '{}']")
  if test $status -eq 0
    commandline -br $current
  end
  commandline -f repaint
end
