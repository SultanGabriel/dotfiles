git_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -n "$branch" ]] && echo "- [${branch}]"
}

# Print Stickman + AK once, then set normal prompt
draw_stickman() {
  # clear
  echo -e "  ○_○   [ $PWD ] $(git_branch)"
  echo -e " --|︻╦╤─"
  echo -e "  / \\ "
}

# Call stickman once
# --- Append only ONCE ---
if ! [[ "${precmd_functions[*]}" =~ "draw_stickman" ]]; then
  precmd_functions+=(draw_stickman)
fi
# Actual prompt (no reprinting stickman!)
PROMPT='%F{green}$ %f'

