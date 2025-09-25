options(repos="http://cloud.r-project.org")
for(p in c("penaltyLearning","future.apply","maps","lars","LambertW","kernlab","data.table","quarto"))if(!requireNamespace(p))install.packages(p)
remotes::install_github("animint/animint2")
unlink("chapters/index_cache/",recursive=TRUE)
quarto::quarto_render("chapters")
## copy data viz to site.
servr::httd("chapters/_book", port=4849)
csess <- chromote::ChromoteSession$new(width=3000, height=2000)
options(chromote.timeout = 120)
csess$Page$navigate("http://127.0.0.1:4849")
csess$Page$navigate("https://tdhock.github.io")
csess$view()
csess$screenshot("screenshot.png", selector=".plot_content")

    chrome.session <- chromote::ChromoteSession$new(
      width=3000, height=2000)
    portNum <- servr::random_port()
    normDir <- normalizePath("chapters/_book", winslash = "/", mustWork = TRUE)
animint2:::start_servr(serverDirectory = normDir, port = portNum, tmpPath = normDir)
chromote_sleep_seconds <- 5
    Sys.sleep(chromote_sleep_seconds)
    url <- sprintf("http://localhost:%d/index.html", portNum)
chrome.session$Page$navigate(url)
out.png <- "Ch01vizKeeling.png"
    screenshot_path <- file.path(normDir, out.png)
    screenshot_full <- sub(".png", "_full.png", screenshot_path)
    Sys.sleep(chromote_sleep_seconds)
## Capture screenshot
##script <- sprintf("document.getElementById('%s').scrollIntoView(true);", id)
chrome.session$Runtime$evaluate("document.getElementById('Ch01vizKeeling').scrollIntoView(true);")
chrome.session$view()
chrome.session$screenshot(screenshot_full, selector = "#Ch01vizKeeling .plot_content")
blist <- get_element_bbox(".plot_content")
image_data <- chrome.session$Page$captureScreenshot(clip=with(blist, list(x = left, y = top, width = width, height = height, scale = 1)))
writeBin(jsonlite::base64_dec(image_data$data), "test.png")
showimage::show_image("test.png")
    image_raw <- magick::image_read(screenshot_full)
    image_trimmed <- magick::image_trim(image_raw)
    magick::image_write(image_trimmed, screenshot_path)
    unlink(screenshot_full)

animint_js_vec <- Sys.glob("chapters/*/*/animint.js")
from_dir_vec <- dirname(animint_js_vec)
to_dir_vec <- dirname(sub("/", "/_book/", from_dir_vec))
from_to_list <- split(from_dir_vec, to_dir_vec)
for(to_dir in names(from_to_list)){
  from_dir <- from_to_list[[to_dir]]
  file.copy(from_dir, to_dir, recursive=TRUE)
}
file.copy("chapters/Ch01vizKeeling", "chapters/_book", recursive=TRUE)
## preview site.
if(interactive())servr::httd("chapters/_book")
