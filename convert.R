from_paths <- grep(
  "Ch0[01]",
  Sys.glob("~/teaching/animint-book/Ch[0-9][0-9]-*"),
  invert=TRUE,
  value=TRUE)
Chxx_vec <- sub("-.*", "", basename(from_paths))
to_list <- split(from_paths, Chxx_vec)
for(Chxx in names(to_list)){
  to_dir <- file.path("~/R/animint-manual-en/chapters", Chxx)
  dir.create(to_dir, showWarnings = FALSE)
  Ch_files <- to_list[[Chxx]]
  file.copy(Ch_files, to_dir, recursive = TRUE)
  Rmd <- grep("Rmd", Ch_files, value=TRUE)
  qmd <- basename(sub("Rmd", "qmd", Rmd))
  qmd_path <- file.path(to_dir, qmd)
  system(sprintf(
    "grep -v '^#[^#]' %s > %s",
    Rmd, qmd_path))
  system(paste("sed -i 's#(Ch\\([0-9]*\\)#(../Ch\\1/Ch\\1#'", qmd_path))
  system(sprintf(
    "sed -i 's/#exercises/#%s-exercises/' %s",
    Chxx, qmd_path))
}
