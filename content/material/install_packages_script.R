# Installing the R packages for the course ------------------------------------
#
# Research Methodology (Fall 2026), Europa-Universität Flensburg
#
# Simply run this whole script, e.g. by pressing Ctrl+Shift+Enter (Windows) or
# Cmd+Shift+Enter (Mac). There is nothing you need to adjust beforehand.
#
# You can re-run this script at any time during the semester: it only installs
# what is missing, and always updates the exercise package.
#
# If something goes wrong, post the file 'InstallationLog.txt' (see the end of
# this script) together with a screenshot of the error in the Moodle forum.

# 1) Tell R where to look for packages ----------------------------------------
# Next to the usual CRAN mirror we use the course package repository, which
# provides ready-made ('binary') versions of the exercise package and its two
# helper packages. This means you do not need any additional developer tools.

options(
  repos = c(
    teachingdatascience = "https://teaching-datascience.r-universe.dev",
    CRAN = "https://cloud.r-project.org"
  ),
  install.packages.check.source = "no",
  install.packages.compile.from.source = "never"
)

# 2) The packages we use during the course ------------------------------------

required_packages <- c(
  "bit64",
  "broom",
  "car",
  "commonmark",
  "countrycode",
  "data.table",
  "effectsize",
  "emmeans",
  "ggdist",
  "gridExtra",
  "haven",
  "here",
  "ineq",
  "kableExtra",
  "learnr",
  "modelsummary",
  "moderndive",
  "patchwork",
  "plm",
  "pwr",
  "remotes",
  "rmarkdown",
  "scales",
  "tidyverse",
  "tinytex",
  "viridis",
  "WDI",
  # The following three come from the course repository:
  "DataScienceExercises",
  "ggcheck",
  "gradethis"
)

# 3) Install what is missing --------------------------------------------------

missing_packages <- setdiff(required_packages, rownames(installed.packages()))

if (length(missing_packages) > 0){
  cat(paste0("Installing ", length(missing_packages), " package(s)...\n"))
  install.packages(missing_packages)
} else {
  cat("All required packages are already installed.\n")
}

# The exercise package is updated regularly during the semester, so we always
# fetch the most recent version:
install.packages("DataScienceExercises")

# 4) Check whether everything worked ------------------------------------------

package_status_list <- list()
for (i in 1:length(required_packages)){
  package_name <- required_packages[i]
  print(package_name)
  package_installed <- require(package_name,
                               character.only = T)
  status_frame <- data.frame(package=package_name,
                             status=package_installed)
  package_status_list[[i]] <- status_frame
}

paket_log <- do.call("rbind", package_status_list)

log_path <- here::here("InstallationLog.txt")
write.table(x = paket_log, file = log_path, row.names = FALSE)

package_status_vector <- paket_log[["status"]]

if (sum(package_status_vector)==length(package_status_vector)){
  print("Excellent! All relevant packages were installed successfully!")
} else{
  cat(paste0(
    "Warning! There were errors when installing some packages!\n",
    "Please have a look into the file 'InstallationLog.txt'.",
    "It was saved here: \n",
    log_path, "\n",
    "If there are only a few packages with a 'FALSE', please try to install ",
    "them separately by executing:\n",
    "install.packages('PACKAGENAME')\n",
    "where 'PACKAGENAME' is the name of the package that failed.\n",
    "Then make a screenshot of the resulting error message and ",
    "post the screenshot as well as the file 'InstallationLog.txt' in ",
    "the Moodle forum so that we can help you!"))
}
