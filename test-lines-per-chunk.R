qmd.files <- c(
  Sys.glob("chapters/*qmd"),
  Sys.glob("chapters/*/index.qmd"))
library(data.table)
shown_dt_list <- list()
for(qmd in qmd.files){
  chunk_dt <- nc::capture_all_str(
    qmd,
    "\n```{r",
    args=".*",
    "\n",
    code_string="(?:.*\n)+?",
    "```"
  )[
  , code_list := strsplit(code_string, "\n")
  ][
  , code_lines := sapply(code_list, length)
  ][]
  this_shown <- chunk_dt[!grepl("echo=FALSE", args)]
  if(nrow(this_shown)){
    shown_dt_list[[qmd]] <- data.table(qmd, this_shown)
  }
}
shown_dt <- rbindlist(shown_dt_list)[order(code_lines)]
print(shown_dt$code_lines)
line.limit <- 100
too_long <- shown_dt[code_lines>line.limit]
for(row_i in 1:nrow(too_long)){
  too_long[row_i, cat(sprintf(
    "%4d / %4d %s %d lines > %d\n%s\n\n",
    row_i, nrow(too_long), qmd, code_lines, line.limit, code_string))]
}
q(status=nrow(too_long))
