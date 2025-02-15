% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bdc_query_names_taxadb.R
\name{bdc_query_names_taxadb}
\alias{bdc_query_names_taxadb}
\title{Harmonizing taxon names against local stored taxonomic databases}
\usage{
bdc_query_names_taxadb(
  sci_name,
  replace_synonyms = TRUE,
  suggest_names = TRUE,
  suggestion_distance = 0.9,
  db = "gbif",
  rank_name = NULL,
  rank = NULL,
  parallel = FALSE,
  ncores = 2,
  export_accepted = FALSE
)
}
\arguments{
\item{sci_name}{character string. Containing scientific names to be queried.}

\item{replace_synonyms}{logical. Should synonyms be replaced by accepted
names? Default = TRUE.}

\item{suggest_names}{logical. Tries to find potential candidate names for
misspelled names not resolved by an exact match. Default = TRUE.}

\item{suggestion_distance}{numeric. A threshold value determining the
acceptable orthographical distance between searched and candidate names.
Names with matching distance value lower threshold informed are returned as
NA. Default = 0.9.}

\item{db}{character string. The name of the taxonomic database to
be used in harmonizing taxon names. Default = "gbif".
Use "all" to install all available taxonomic databases automatically.}

\item{rank_name}{character string. Taxonomic rank name (e.g. "Plantae",
"Animalia", "Aves", "Carnivora". Default = NULL.}

\item{rank}{character string. A taxonomic rank used to filter the
taxonomic database. Options available are: "kingdom", "phylum", "class",
"order", "family", and "genus".}

\item{parallel}{logical. Should a parallelization process be used?
Default=FALSE}

\item{ncores}{numeric. The number of cores to run in parallel.}

\item{export_accepted}{logical. Should a table containing records
with names linked to multiple accepted names saved for further
inspection. Default = FALSE.}
}
\value{
This function returns data.frame containing the results of the
taxonomic harmonization process. The database is returned in the same order
of sci_name.
}
\description{
Harmonizing taxon names against local stored taxonomic databases
}
\details{
The taxonomic harmonization is based upon one taxonomic authority database.
The lastest version of each database is used to perform queries, but
note that only older versions are available for some taxonomic databases. The
database version is shown in parenthesis. Note that some databases are
momentary unavailable in taxadb.
\itemize{
\item \strong{itis}: Integrated Taxonomic Information System (v. 2022)
\item \strong{ncbi}: National Center for Biotechnology Information (v. 2022)
\item \strong{col}: Catalogue of Life (v. 2022)
\item \strong{tpl}: The Plant List (v. 2019)
\item \strong{gbif}: Global Biodiversity Information Facility (v. 2022)
\item \strong{fb}: FishBase (v. 2019)
\item \strong{slb}: SeaLifeBase (unavailable)
\item \strong{wd}: Wikidata (unavailable)
\item \strong{ott}: OpenTree Taxonomy (v. 2021)
\item \strong{iucn}: International Union for Conservation of Nature (v. 2022)
}

The bdc_query_names_taxadb processes as this:

\strong{Creation of a local taxonomic database}

This is a one-time setup used to download, extract, and import the taxonomic
databases specified in the argument "db". The downloading process may take a
few minutes depending on your connection and database size. By default, the
"gbif" database following a Darwin Core schema is installed. (see
?taxadb::td_create for details).

\strong{Taxonomic harmonization}

The taxonomic harmonization is divided into two distinct phases according to
the matching type to be undertaken.

\strong{Exact matching}

Firstly, the algorithm attempts to find an exact matching
for each original scientific name supplied using the function "filter_name"
from taxadb package. If an exact matching cannot be found, names are returned
as Not Available (NA). Also, it is possible that a scientific name match
multiple accepted names. In such cases, the "bdc_clean_duplicates" function
is used to flag and remove names with multiple accepted names.

Information on higher taxa (e.g., kingdom or phylum) can be used to
disambiguate names linked to multiple accepted names. For example, the genus
"Casearia" is present in both Animalia and Plantae kingdoms. When handling
names of Plantae, it would be helpful to get rid of names belonging to the
Animalia to avoid flagging "Caseria" as having multiple accepted names.
Following Norman et al. (2020), such cases are left to be fixed by the user.
If "export_accepted" = TRUE a database containing a list of all records with
names linked to multiple accepted names is saved in the "Output" folder.

\strong{Fuzzy matching}

Fuzzy matching will be applied when "suggest_names" is TRUE and only for
names not resolved by an exact match. In such cases, a fuzzy matching
algorithm processes name-matching queries to find a potential matching
candidate from the specified taxonomic database. Fuzzy matching identifies
probable names (here identified as suggested names) for original names via a
measure of orthographic similarity (i.e., distance). Orthographic distance is
calculated by optimal string alignment (restricted Damerau-Levenshtein
distance) that counts the number of deletions, insertions, substitutions, and
adjacent characters' transpositions. It ranges from 0 to 1, being 1 an
indicative of a perfect match. A threshold distance, i.e. the lower value of
match acceptable, can be informed by user (in the "suggest_distance"
argument). If the distance of a candidate name is equal or higher than the
distance informed by user, the candidate name is returned as suggested name.
Otherwise, names are returned as NA.

To increase the probability of finding a potential match candidate and to
save time, two steps are taken before conducting fuzzy matching. First, if
supplied, information on higher taxon (e.g., kingdom, family) is used to
filter the taxonomic database. This step removes matching ambiguity by
avoiding matching names from unrelated taxonomic ranks (e.g., match a plant
species against a taxonomic database containing animal names) and decreases
the number of names in the taxonomic database used to calculate the matching
distance. Then, the taxonomic database is filtered according to a set of
firsts letters of all input names. This process reduces the number of names
in the taxonomic database to which each original name should be compared When
a same suggested name is returned for different input names, a warning is
returned asking users to check whether the suggested name is valid.

\strong{Report}

The name harmonization processes' quality can be accessed in the column
"notes" placed in the table resulting from the name harmonization process.
The column "notes" contains assertions on the name harmonization process
based on Carvalho (2017). The notes can be grouped in two categories:
accepted names and those with a taxonomic issue or warning, needing further
inspections. Accepted names can be returned as "accepted" (valid accepted
name), "replaceSynonym" (a synonym replaced by an accepted name),
"wasMisspelled" (original name was misspelled), "wasMisspelled |
replaceSynonym" (misspelled synonym replaced by an accepted name), and
"synonym" (original names is a synonym without accepted names in the
database). Similarly, the following notes are used to flag taxonomic issues:
"notFound" (no matching name found), "multipleAccepted" (name with multiple
accepted names), "noAcceptedName" (no accepted name found), and ambiguous
synonyms such as "heterotypic synonym", "homotypic synonym", and "pro-parte
synonym". Ambiguous synonyms, names that have been published more than once
describing different species, have more than one accepted name and cannot be
resolved. Such cases are flagged and left to be determined by the user.
}
\examples{
\donttest{
if (interactive()) {
  sci_name <- c(
    "Polystachya estrellensis",
    "Tachigali rubiginosa",
    "Oxalis rhombeo ovata",
    "Axonopus canescens",
    "Prosopis",
    "Haematococcus salinus",
    "Monas pulvisculus",
    "Cryptomonas lenticulari",
    "Poincianella pyramidalis",
    "Hymenophyllum polyanthos"
  )

  names_harmonization <-
    bdc_query_names_taxadb(
      sci_name,
      replace_synonyms = TRUE,
      suggest_names = TRUE,
      suggestion_distance = 0.9,
      db = "gbif",
      parallel = TRUE,
      ncores = 2,
      export_accepted = FALSE
    )
}
}
}
\seealso{
Other taxonomy: 
\code{\link{bdc_clean_names}()},
\code{\link{bdc_filter_out_names}()}
}
\concept{taxonomy}
