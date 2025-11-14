options(repos="http://cloud.r-project.org")
for(p in c("penaltyLearning","future.apply","maps","lars","LambertW","kernlab","data.table","quarto","chromote","magick","mlr3torch","glmnet","kknn","mlr3learners","mlr3tuning","WeightedROC"))if(!requireNamespace(p))install.packages(p)
remotes::install_github("animint/animint2")
remotes::install_github("animint/animint2data")
unlink("chapters/_book", recursive = TRUE)
quarto::quarto_render("chapters")
## copy data viz to site.
for(glob in c("chapters/*/animint.js", "chapters/ch*/*/animint.js")){
  animint_js_vec <- Sys.glob(glob)
  from_dir_vec <- dirname(animint_js_vec)
  to_dir_vec <- dirname(sub("/", "/_book/", from_dir_vec))
  from_to_list <- split(from_dir_vec, to_dir_vec)
  for(to_dir in names(from_to_list)){
    from_dir <- from_to_list[[to_dir]]
    print(to_dir)
    file.copy(from_dir, to_dir, recursive=TRUE)
  }
}
## preview site.
if(interactive())servr::httd("chapters/_book")
