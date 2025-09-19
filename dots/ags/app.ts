import app from "ags/gtk4/app"
import style from "./src/styles/style.scss"
import Bar from "./src/layout/bar/Bar"

app.start({
  css: style,
  main() {
    app.get_monitors().map(Bar)
  },
})
