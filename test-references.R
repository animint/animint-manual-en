qmd.files <- c(
  Sys.glob("chapters/*qmd"),
  Sys.glob("chapters/*/index.qmd"))
library(data.table)
violations <- list()
for(qmd in qmd.files){
  link_dt <- nc::capture_all_str(
    qmd,
    "\\]\\(",
    url="http.*?",
    "\\)")
  if(nrow(link_dt)){
    violations[[qmd]] <- link_dt$url
  }
}
print(violations)

q(status=length(violations))
