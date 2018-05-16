
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

con() {
    prod='lax1 sjc1 dal1 ord1 lga1 iad1 mia1 lon1 fra1 ams1'
    staging='phx1 ams2'
    lab='phx2 ams3'
    site=`echo $1 | sed 's/-.*//'`
    if [[ " $prod " =~ .*\ $site\ .* ]]; then
        env='dlvr1.net'
    elif [[ " $staging " =~ .*\ $site\ .* ]]; then
        env='dlvr0.net'
    elif [[ " $lab " =~ .*\ $site\ .* ]]; then
        env='dlvrtest.com'
    fi
    ssh $1.$site.$env
}
