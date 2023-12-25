# My blog's utiilties and aliases
template=$(find ./_scaffolds | grep .md)
usage="Usage:\tctl\tpush/fetch/stat/add/new/open <fname_reg>/find <fname_reg>/lines"

function ctl() {
    if [[ $1 == "push" ]]; then
        git add . && git commit -m "Vault backup $(date)" && git push 
    elif [[ $1 == "fetch" ]]; then
        git pull --rebase && echo "pull completed"
    elif [[ $1 == "stat" ]]; then
        git status
    elif [[ $1 == "add" ]]; then
        git add . && git status
    elif [[ $1 == "new" ]]; then
        new_post $2 && vim "_inbox/$2.md"
    elif [[ $1 == "open" ]]; then
        open $2
    elif [[ $1 == "find" ]]; then
        find . -type f -not -path './git/*' -name $2
    elif [[ $1 == "lines" ]]; then
        line_count
    else
        echo -e $usage
    fi 
}

function deploy() {
    cd ..
    (
        rm -rf deploy && cp -r blog deploy
        cd deploy && git checkout deploy
        cp -r blog deploy/source
        cd deploy && pnpm i && pnpm run server
    )
}

function image_url_proc() {
    find . -type f -name "*.md" -exec sed -i 's/\!\[\[\(.*\)\/\(.*\)\]\]/\!\[\2\]\(\/img\/\2\)/gi' {}
}

function new_post() {
    content=$(cat $template | sed -e "s/{{title}}/$1/" -e "s/{{date}} {{time}}/$(date '+%Y-%m-%d %H:%M:%S')/g")
    fname="_inbox/$1.md"
    if [ -e $fname ];then
        echo "File already exists"
    else
        echo -e "$content" > "$fname"
    fi
}

function line_count() {
    echo "You have wrote $(find _* -type f -name *.md | xargs cat 2>/dev/null | wc -l) lines in total!"
}

function knote() {
    datetime=$(date '+%Y-%m-%d-%H:%M:%S')
    echo -e $(sed -e "s/{{title}}/$datetime/" -e "s/{{date}} {{time}}/$(date '+%Y-%m-%d %H:%M:%S')/" $template) > "_inbox/$datetime.md"
    vim "_inbox/$datetime.md"
}

function open() {
    vim $(find . -type f -not -path './git/*' -name $1)
}

