# ANSIBLE MANAGED FILE - wsl-setup

eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/jeremyj563/wsl-setup/master/files/oh-my-posh/themes/jj.omp.json')"

alias omp='oh-my-posh'
function p() {
    for segment in command kubectl os path time go python; do
        oh-my-posh toggle $segment
    done
}
