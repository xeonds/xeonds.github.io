
function ctl(){
  NAME="Mastering C: Unleashing the Power of Advanced Programming.md"
  case $1 in
    out)
      pandoc -w latex -o book.tex ./"$NAME"
      ;;
    hi)
      echo "Hello, $(cat ./*.md | wc -w ) words in total!"
      ;;
    open)
      vim ./"$NAME"
      ;;
    html)
      pandoc -f markdown -t html "$NAME" -o index.html
      ;;
    *)
      echo "Usage: ctl out|hi|open|html"
      ;;
  esac
}

ctl hi
