# https://raphaelnussbaumer.com/GeoPressureManual/geopressuretemplate-workflow.html
library(GeoPressureR)

# Get all the tag_id
list_id <- tail(names(yaml::yaml.load_file("config.yml", eval.expr = FALSE)), -1)


## OPTION 1: Run workflow step-by-step for a single tag
id <- "CS759" # Run a single tag
geopressuretemplate_config(id)
tag <- geopressuretemplate_tag(id)
graph <- geopressuretemplate_graph(id)
geopressuretemplate_pressurepath(id)


load(paste0("data/interim/" ,id,".RData"))


geopressureviz(
  tag,
  path = pressurepath,
  path = path_mostlikely,
  marginal = marginal
)

plot_path(path_most_likely, plot_leaflet = T)

plot_path(path_geopressureviz, plot_leaflet = T)

plot_pressurepath(pressurepath_most_likely, type = "altitude")


#####

bird <- bird_create(config::get("bird_create", id)$scientific_name)

Bird_ID <- paste0(id, "_", bird$scientific_name)  # Concatenate the scientific name with the ID


### most likely marginal path as .csv
write.csv2(path_most_likely,
           file = paste0("output/", Bird_ID, "_most_likely_path.csv"),
           row.names = FALSE)

### Geopressureviz cleaned path as .csv
write.csv2(path_geopressureviz,
           file = paste0("output/", Bird_ID, "_path_geopressureviz.csv"),
           row.names = FALSE)


### Year round altitude as .csv
write.csv2(pressurepath_most_likely,
           file = paste0("output/", Bird_ID, "_altitudes_year_round.csv"),
           row.names = FALSE)





## OPTION 2: All tracks, step-by-step

# 1. Compute likelihood map
for (id in list_id){
  geopressuretemplate_tag(id)
}

# 2. (optional) Manual check of labeling
# geopressureviz("18LX")

# 3. (optional) Add wind if not done before
for (id in list_id){
  cli::cli_h1("Run tag_download_wind for {id}")
  load(glue::glue("./data/interim/{id}.RData"))
  tag_download_wind(tag)
}

# 4. Run graph
for (id in list_id){
  geopressuretemplate_graph(id)
}

# 5. Run pressurepath
for (id in list_id){
  geopressuretemplate_pressurepath(id)
}


## OPTION 3: Run entire workflow for all tags
for (id in list_id){
  geopressuretemplate(id)
}

