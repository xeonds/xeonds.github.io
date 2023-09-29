# My blog's utiilties and aliases
set -e
TMPL=$(find ./_scaffolds | grep .md)

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
    sed -e "s/{{title}}/$1/" -e "s/{{date}} {{time}}/$(date '+%Y-%m-%d %H:%M:%S')/" $TMPL
}

function line_count() {
    echo "You have wrote $(find _* -type f -name *.md | xargs cat 2>/dev/null | wc -l) lines in total!"
}

function push_to_github() {
    git add . && git commit -m "Vault backup $(date)"
    git push
}
