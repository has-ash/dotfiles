function __complete_git_remote_branches
  git for-each-ref --format="%(refname:lstrip=3)" refs/remotes/
end

complete -f -c create-worktree -a "(__complete_git_remote_branches)" -d "Create worktree for a remote branch"
