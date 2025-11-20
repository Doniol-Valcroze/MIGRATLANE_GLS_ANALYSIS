library(GeoLocatoR)
library(zen4R)
library(frictionless)
library(GeoPressureR)

## Publish Data Package
# Introduction: hhttps://raphaelnussbaumer.com/GeoPressureManual/geolocator-intro.html
# Detailed instruction: https://raphaelnussbaumer.com/GeoPressureManual/geolocator-create.html

# install.packages("pak")
# pak::pkg_install("Rafnuss/GeoLocatoR")
# pak::pkg_install("Rafnuss/GeoPressureR@dev")
# pak::pkg_install("Rafnuss/GeoLocatoR@dev")

# Create the datapackage
rm(list=ls())
gc()

pkg <- create_gldp_geopressuretemplate(directory = "C:/Users/pdoniolvalcroze/Desktop/MIGRATLANE_Analysis")

#print(pkg)

# title
pkg$title <- "GeoLocator Data Package: MIGRATLANE - Monitoring and studying birds in the North-East Atlantic Arc"

# Contributors/creators:
# Default is to take the GeoPressureTemplate authors, but it is common that
# additional co-authors should be added for the datapackage
pkg$contributors <- list(
  list(
    title = "Paul Doniol-Valcroze",
    roles = c("ContactPerson", "DataCurator", "ProjectLeader"),
    email = "paul.doniol-valcroze@mnhn.fr",
    path = "https://orcid.org/0000-0002-2523-5979",
    organization = "CESCO - MNHN"
  ),

  list(
    title = "Frédéric Jiguet",
    roles = c("ContactPerson", "ProjectLeader"),
    email = "frederic.jiguet@mnhn.fr",
    organization = "CESCO - MNHN"
  ),

  list(
    title = "Sophie de Grissac",
    roles = c("ContactPerson", "ProjectLeader"),
    email = "sophie.degrissac@mnhn.fr",
    organization = "CESCO - MNHN"
  ),

  list(
    title = "Pierrick Bocher",
    roles = c("ProjectLeader"),
    email = "pierrick.bocher@univ-lr.fr",
    organization = "UMR LIENS"
  ),

  list(
    title = "Yannig Coulomb",
    roles = c("datacollector"),
    organization = "CESCO - MNHN"
  ),

  list(
    title = "Fanny Rey",
    roles = c("datacollector"),
    organization = "UMR LIENS"
  ),

  list(
    title = "Rose Delacroix",
    roles = c("datacollector"),
    organization = "CESCO - MNHN"
  )
)


# There are no embargo by default (1970-01-01)
pkg$embargo <- "2027-01-01"

# Licences
# Code licenses are often not the same as data licences.
pkg$licenses = list(list(
  name = "CC-BY-4.0",
  title = "Creative Commons Attribution 4.0",
  path = "https://creativecommons.org/licenses/by/4.0/"
))

# Review the description, often, you want to be more descriptive here.
pkg$description <- "The MIGRATLANE research programme is part of the development of offshore wind power along the French Channel-Atlantic coastline.
Planning maritime developments for the energy transition must be accompanied by a good understanding of the animal species that frequent these areas in order to ensure their preservation.
The French Biodiversity Agency (OFB) has therefore launched and is leading a research programme aimed at collecting data and characterising migratory flows, flight behaviour and altitudes, as well as maritime areas of importance for seabirds, land birds and bats.
The programme consists of six complementary components: visual, radar, acoustic and aerial monitoring, and of course data analysis and modelling.
Component 2, which is the subject of this data-package, focuses on telemetric monitoring of birds."

# Add keywords
pkg$keywords <- c("Biologging", "Collision","Offshore wind farm", "Migratory birds", "Multi-sensor geolocator",
                  "Acrocephalus schoenobaenus",
                  "Anthus pratensis",
                  "Anthus trivialis",
                  "Caprimulgus europaeus",
                  "Curruca communis",
                  "Luscinia megarhynchos",
                  "Luscinia svecica",
                  "Motacilla flava",
                  "Muscicapa striata",
                  "Oenanthe oenanthe",
                  "Hirundo rustica",
                  "Apus apus",
                  "Emberiza schoeniclus")

# Funding sources
pkg$grants <- c("French Biodiversity Agency (OFB)")

#pkg$bibliographicCitation <- c("To be filled")

# Related Identifiers
# e.g. papers, project pages, derived datasets, etc.
#pkg$relatedIdentifiers <- list(
#  list(relationType = "IsPartOf", relatedIdentifier = "10.5281/zenodo.11207081", relatedIdentifierType = "DOI"))



#pkg <- add_gldp_geopressuretemplate(pkg)
#
# write.csv(tags(pkg), file = "data/tags.csv", row.names = FALSE)
# write.csv(observations(pkg), file = "data/observations.csv", row.names = FALSE)


library(frictionless)
library(GeoLocatoR)
library(tidyverse)
library(ggplot2)
library(leaflet)


pkg <- read_gldp("C:/Users/pdoniolvalcroze/Desktop/MIGRATLANE_Analysis/data/datapackage/datapackage.json")


print(pkg)

plot(pkg, "ring")

plot(pkg, "coverage")

plot(pkg, "map")

validate_gldp(pkg)


#write_package(pkg, directory = "data/datapackage")



#### Publication on ZENODO
library(zen4R)

keyring::key_set_with_value("ZENODO_PAT", password = "DpIFBX1uVsQq3U4lDJ9AXLSmJlTDXFbOyYTjHRloiYyIhASsnkaYEeeohvN6")

zenodo <- ZenodoManager$new(token = keyring::key_get(service = "ZENODO_PAT"))

z <- gldp_to_zenodo(pkg)

print(z)


z <- zenodo$depositRecord(z, reserveDOI = TRUE, publish = FALSE)


pkg$id <- paste0("https://doi.org/", z$getConceptDOI())


write_package(pkg, directory = "data/datapackage")

for (f in list.files("data/datapackage")) {
  zenodo$uploadFile(file.path("data/datapackage", f), z)
}



