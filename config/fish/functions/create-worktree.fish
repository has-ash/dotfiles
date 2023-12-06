function create-worktree -a remote_branch
  if string match -q "origin/*" $remote_branch
    set local_branch (string sub -s 7 $remote_branch)
  else
    set branch_name $remote_branch
  end

  echo "remote: $remote_branch \nlocal: $local_branch"

  # check if local branch already exists
  if git show-ref --verify --quiet refs/heads/$branch_name
    echo "Local branch already exists."]
  else
    git checkout -b $branch_name $remote_branch
    echo "Creating local branch from remote"
  end

  # create a directory with the branch and initialize a worktree
  set worktree_base ~/dev/worktrees
  set worktree_dir $worktree_base/$branch_name
  mkdir --verbose -p $worktree_dir
  git worktree add $worktree_dir $branch_name
  echo 'Initialized worktree in ($worktree_dir).'
end
