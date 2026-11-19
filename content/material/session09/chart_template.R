# A template for a good chart: how much does a variable vary within groups?
#
# The chart: one box plot per continent, every country as a point on top,
# and a label for one country per continent. This version shows GDP per
# capita and labels the richest country. To show another variable, change
# the lines marked "<- CHANGE".

library(ggplot2)
library(dplyr)

# the data: one row per country in 2007 (as DataScienceExercises::gdplifexp2007)
gdp_data <- read.csv("data/gdplifexp2007.csv")

base_size <- 14   # font size of the whole chart: larger for slides
edge_space <- expansion(mult = 0.1)  # 10% extra room at both ends of the
                                     # x-axis, so that no label is cut off


# 1. The number for the title -- computed, never typed ----------------------

spread <- gdp_data |>
  group_by(continent) |>
  summarise(ratio = max(gdpPercap) / min(gdpPercap))      # <- CHANGE

asia_ratio <- spread$ratio[spread$continent == "Asia"]    # <- CHANGE


# 2. The countries that get a label: one per continent ----------------------

label_data <- gdp_data |>
  group_by(continent) |>
  slice_max(gdpPercap, n = 1)    # <- CHANGE: slice_max() = highest,
                                 #    slice_min() = lowest


# 3. The chart ---------------------------------------------------------------

my_chart <- ggplot(
  data = gdp_data,
  # the variable on x, the groups on y: long group names stay readable
  mapping = aes(x = gdpPercap, y = continent)              # <- CHANGE
) +
  # the box: median, middle half of the countries, and the range.
  # outlier.shape = NA hides the box's own outlier dots, because the
  # points below show every country anyway
  geom_boxplot(outlier.shape = NA, width = 0.6, colour = "grey50") +
  # every country as one point; alpha = 0.4 makes them see-through, so
  # where many countries overlap, the colour gets darker
  geom_point(alpha = 0.4, size = 2.5, colour = "#00395B") +
  # the labelled countries again, on top and in red ...
  geom_point(data = label_data, size = 3, colour = "#E65032") +
  # ... and their names, placed just above each box
  geom_text(
    data = label_data, mapping = aes(label = country),
    nudge_y = 0.4, size = base_size / 3.5, colour = "#E65032") +

  # x-axis: keep ONE of the two lines, put a # in front of the other.
  # log axis: for skewed variables such as income or population
  scale_x_log10(labels = scales::label_dollar(accuracy = 1), expand = edge_space) +
  # linear axis: for most other variables, e.g. life expectancy
  # scale_x_continuous(expand = edge_space) +

  labs(
    # the title states the finding, with the number computed above
    title = paste0("In Asia, the richest country is ", round(asia_ratio),
                   " times as rich as the poorest"),      # <- CHANGE
    subtitle = "GDP per capita, 142 countries, 2007",     # <- CHANGE
    x = "GDP per capita (log scale)",                     # <- CHANGE: with unit
    y = NULL,                       # the continent names speak for themselves
    caption = "Data: Gapminder."    # always name the source
  ) +
  theme_minimal(base_size = base_size) +
  theme(
    plot.title            = element_text(face = "bold"),
    plot.title.position   = "plot",     # title flush with the left edge
    plot.caption          = element_text(colour = "grey45", hjust = 1),
    plot.caption.position = "plot",
    panel.grid.minor      = element_blank(),  # fewer lines, less clutter
    legend.position       = "top",      # if you add a legend: on top, left
    legend.justification  = "left"
  )

my_chart


# 4. Save it at a fixed size, so it looks the same every time ----------------

ggsave("my_chart.png", plot = my_chart, width = 8, height = 5, dpi = 300)
