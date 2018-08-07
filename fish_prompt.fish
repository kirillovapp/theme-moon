# name: moon (based on mars)
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l last_status $status

  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)

  set -l color_normal (set_color normal)
  set -l color_whoami (set_color green)

  if test $last_status = 0
      set arrow " $green>︎︎"
  else
      set arrow " $red>︎︎"
  end
  set -l cwd $cyan(prompt_pwd)

  if [ (_git_branch_name) ]
    set git_branch (_git_branch_name)

    if [ (_is_git_dirty) ]
      set git_info "$blue ($yellow$git_branch±$blue)"
    else
      if test (_git_branch_name) = 'master'
        set git_info "$blue ($red$git_branch$blue)"
      else
        set git_info "$blue ($color_normal$git_branch$blue)"
      end
    end
  end

  echo -n -s $color_whoami (whoami) @ (hostname|cut -d . -f 1) ": " $cwd $git_info $arrow $color_normal ' '
end

