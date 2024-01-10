function ctl(){
  case $1 in
    out)
      pandoc -w latex -o book.tex ./"Mastering C: Unleashing the Power of Advanced Programming.md"
      ;;
    hi)
      echo "Hello, $(cat ./*.md | wc -w ) words in total!"
      ;;
    open)
      vim ./"Mastering C: Unleashing the Power of Advanced Programming.md"
      ;;
    *)
      echo "Usage: ctl out"
      ;;
  esac
}

ctl hi
