# Figures for the lab 9 deck (E9-AICoding.qmd).
#
# The deck contains no R chunks; it shows these PNGs. Run this script from
# OUTSIDE the project directory, so that the project's renv does not load:
#
#   cd /tmp && LC_ALL=en_US.UTF-8 Rscript \
#     <path-to-project>/content/material/slides/figures/E9/make-figures.R
#
# Needs: tidyverse, scales, ggrepel, gapminder, DataScienceExercises.

suppressPackageStartupMessages({
  library(tidyverse)
  library(scales)
  library(ggrepel)
  library(DataScienceExercises)
})

out_dir <- dirname(normalizePath(sub("--file=", "", grep(
  "--file=", commandArgs(FALSE), value = TRUE))))

euf_blue  <- "#00395B"
euf_light <- "#69AACD"
euf_red   <- "#E65032"
euf_gray  <- "#6F6F6F"

theme_deck <- function(base_size = 17) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      plot.caption          = element_text(colour = euf_gray, hjust = 1),
      panel.grid.minor      = element_blank(),
      legend.position       = "top",
      legend.justification  = "left",
      strip.text            = element_text(face = "bold", colour = euf_blue)
    )
}

save_fig <- function(plot, name, width = 10, height = 4.6) {
  ggsave(file.path(out_dir, name), plot, width = width, height = height,
         dpi = 160, bg = "white")
}

# ---------------------------------------------------------------------------
# 1. What the vague prompt returns: gapminder::gapminder, all twelve years,
#    linear axis, a straight regression line.
# ---------------------------------------------------------------------------
vague <- ggplot(data = gapminder::gapminder,
                mapping = aes(x = gdpPercap, y = lifeExp, colour = continent)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ x, colour = "black", se = FALSE) +
  labs(x = "gdpPercap", y = "lifeExp", colour = NULL) +
  theme_deck()
save_fig(vague, "E9-vague.png")

# ---------------------------------------------------------------------------
# 2. What the good prompt (or the adapted template) returns: our data,
#    2007 only, log axis, one panel per continent, biggest country labelled.
# ---------------------------------------------------------------------------
gdp_data <- as_tibble(gdplifexp2007)
biggest  <- gdp_data |> group_by(continent) |> slice_max(pop, n = 1)

good <- ggplot(data = gdp_data,
               mapping = aes(x = gdpPercap, y = lifeExp, size = pop)) +
  geom_point(alpha = 0.6, shape = 21, fill = euf_light, colour = euf_blue) +
  geom_text_repel(data = biggest, mapping = aes(label = country),
                  size = 4.2, colour = euf_blue, min.segment.length = 0,
                  seed = 1) +
  scale_x_log10(breaks = c(1000, 10000), labels = c("$1k", "$10k")) +
  scale_size_continuous(range = c(0.8, 14), guide = "none") +
  facet_wrap(~ continent, nrow = 1) +
  labs(x = "GDP per capita (log scale)", y = "Life expectancy in years",
       caption = "Data: Gapminder, 2007; DataScienceExercises::gdplifexp2007") +
  theme_deck(base_size = 15)
save_fig(good, "E9-good.png", height = 4.2)

# ---------------------------------------------------------------------------
# 3. Code that runs and is wrong: the continent "average" of GDP per capita.
#    aggGDPlifexp (session 8) holds unweighted means over countries, so in
#    2007 Asia looks richer than the Americas. Per person it is the opposite.
# ---------------------------------------------------------------------------
means <- gdp_data |>
  group_by(continent) |>
  summarise(n = n(),
            `Mean over countries`        = mean(gdpPercap),
            `Mean over people (weighted)` = weighted.mean(gdpPercap, pop),
            .groups = "drop")
print(means)

means_long <- means |>
  pivot_longer(starts_with("Mean"), names_to = "summary",
               values_to = "gdp") |>
  mutate(summary = factor(summary, levels = c("Mean over countries",
                                              "Mean over people (weighted)")),
         continent = factor(continent, levels = rev(c(
           "Africa", "Americas", "Asia", "Europe", "Oceania"))))

bars <- function(which) {
  ggplot(data = filter(means_long, summary %in% which),
         mapping = aes(y = continent, x = gdp, fill = summary)) +
    geom_col(position = position_dodge2(reverse = TRUE, preserve = "single"),
             width = 0.75) +
    scale_fill_manual(values = c("Mean over countries" = euf_light,
                                 "Mean over people (weighted)" = euf_blue),
                      drop = FALSE, limits = levels(means_long$summary)) +
    scale_x_continuous(labels = label_dollar(), limits = c(0, 34000),
                       expand = expansion(mult = c(0, 0.02))) +
    labs(x = "GDP per capita, 2007", y = NULL, fill = NULL) +
    theme_deck() +
    theme(panel.grid.major.y = element_blank())
}
save_fig(bars("Mean over countries"), "E9-mean-1.png", height = 4.3)
save_fig(bars(levels(means_long$summary)), "E9-mean-2.png", height = 4.3)

# ---------------------------------------------------------------------------
# 4. Preview for the appendix: the chart template students get in lab09.zip
#    (session09/chart_template.R), run exactly as it is.
# ---------------------------------------------------------------------------
# chdir = TRUE: the template reads data/gdplifexp2007.csv relative to its
# own folder; the my_chart.png it saves there is deleted again right after.
template_dir <- normalizePath(file.path(out_dir, "../../../session09"))
template_env <- new.env()
sys.source(file.path(template_dir, "chart_template.R"), envir = template_env,
           chdir = TRUE)
unlink(file.path(template_dir, "my_chart.png"))
ggsave(file.path(out_dir, "E9-template.png"), template_env$my_chart,
       width = 8, height = 5, dpi = 160, bg = "white")

# ---------------------------------------------------------------------------
# Numbers quoted on the slides
# ---------------------------------------------------------------------------
africa <- as_tibble(aggGDPlifexp) |>
  filter(continent == "Africa", year %in% c(1952, 2007))
cat("\nAfrica, life expectancy (unweighted mean):\n")
print(africa |> select(year, lifeExp))
cat("Change:", round(diff(africa$lifeExp), 1), "years\n")
cat("Countries per continent:\n")
print(count(gdp_data, continent))

# Slide "Never let it write a number": compute first, then paste
change <- as_tibble(aggGDPlifexp) |>
  filter(continent == "Africa") |>
  summarise(change = lifeExp[year == 2007] - lifeExp[year == 1952]) |>
  pull(change)
print(paste("Since 1952, life expectancy in Africa rose by",
            round(change, 1), "years"))
