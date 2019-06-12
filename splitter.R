install.packages(c('furrr', 'tidyverse'))
# install ffmpeg on your machine from here: https://ffmpeg.org/
library(furrr)
library(tidyverse)
plan(multiprocess)

discs <- read.csv('metadata.csv', stringsAsFactors = F)

future_map(1:nrow(discs), function(x) {
  if (!dir.exists(paste0('discs_split/disc_', discs$disc[x]))) {
    dir.create(paste0('discs_split/disc_', discs$disc[x]))
  }

  filepath <- str_glue('discs_original/Radiohead - MINIDISCS -HACKED- - {str_pad(discs$disc[x], width = 2, side = "left", pad = 0)} MD{discs$disc[x] + 110}.mp3')
  
command <- str_glue('ffmpeg -i "{og_filepath}" -metadata title="{title}" -metadata track={track} -metadata disc={disc} -ss {start_time} -t {length} "{outfile}.mp3"',
                      disc = discs$disc,
                      start_time = discs$start_time[x],
                      og_filepath = filepath,
                      length = discs$length[x],
                      title = discs$title[x],
                      track = discs$track_number[x],
                      disc = discs$disc[x],
                      outfile = paste0('discs_split/disc_', discs$disc[x], '/', discs$title[x]))
  system(command, intern = TRUE)
}, .progress = TRUE)
