options(repos="http://cloud.r-project.org")
for(p in c("penaltyLearning","future.apply","maps","lars","LambertW","kernlab","data.table","quarto"))if(!requireNamespace(p))install.packages(p)
remotes::install_github("animint/animint2")
quarto::quarto_render("chapters")
if(interactive())servr::httd("chapters/_book/")
animint_js_vec <- Sys.glob("chapters/*/*/animint.js")
from_dir_vec <- dirname(animint_js_vec)
to_dir_vec <- dirname(sub("/", "/_book/", from_dir_vec))
from_to_list <- split(from_dir_vec, to_dir_vec)
for(to_dir in names(from_to_list)){
  from_dir <- from_to_list[[to_dir]]
  file.copy(from_dir, to_dir, recursive=TRUE)
}

