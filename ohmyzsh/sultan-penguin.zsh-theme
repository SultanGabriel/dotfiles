# Colors (optional, but let's keep it monochrome & clean)
autoload -U colors && colors

# Function to fetch current Git branch
git_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ -n "$branch" ]]; then
    echo "(git)-[$branch]-"
  fi
}

# Main PROMPT
PROMPT=$'\n%{\e[0m%} <o    [%n@%m] - [%~]\n<( '

# Inject Git branch info if available
PROMPT+='$(git_branch)'

PROMPT+=')> \$ '

# For extra spacing between commands
# PROMPT+=$'\n'

