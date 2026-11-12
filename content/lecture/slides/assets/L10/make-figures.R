# =============================================================================
# RM26 L10 — Regression analysis: figures and numbers for the slides
#
# The deck itself contains no R code (lecture decks are plain Markdown), so the
# figures are produced here and included as PNGs. Every number quoted on a
# slide is printed at the end of this script — re-run it and compare whenever
# the data or a model specification changes.
#
# Run from a directory WITHOUT the project's .Rprofile (otherwise renv is
# activated and the global library is not used), and in a UTF-8 locale
# (otherwise "×" in the labels is drawn as ".."), e.g.
#   cd /tmp && LC_ALL=en_US.UTF-8 Rscript /path/to/content/lecture/slides/assets/L10/make-figures.R
#
# Data: CPS Merged Outgoing Rotation Groups 2014, as distributed with
# Békés & Kézdi (2021), Data Analysis for Business, Economics, and Policy
# (https://gabors-data-analysis.com/datasets/cps-earnings). Same sample as on
# the hub page "Categorical Variables and Interaction Terms in Regression":
# market research analysts (occ2012 == 735), aged 24-64, >= 20 hours a week.
#
# The extract written to content/material/data/ is the data set of the lab
# (session 10); lecture and lab therefore work on exactly the same 252 rows.
# =============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(patchwork)
  library(ragg)
})

# ---- paths ------------------------------------------------------------------
script_dir <- local({
  args <- commandArgs(trailingOnly = FALSE)
  f <- sub("^--file=", "", args[grep("^--file=", args)])
  if (length(f) == 1) dirname(normalizePath(f)) else getwd()
})
project_root <- normalizePath(file.path(script_dir, "../../../../.."))
out_dir      <- script_dir
extract_file <- file.path(project_root, "content/material/data/cps-earnings-mra-2014.csv")
# Full CPS file (30 MB, not part of this repository). Only needed to (re)build
# the extract; download it from the URL above if the extract is missing.
raw_file <- Sys.getenv(
  "CPS_MORG_FILE",
  "~/repos/webpages/methodhub/resources/data/morg-2014-emp.csv"
)

# ---- data -------------------------------------------------------------------
if (!file.exists(extract_file)) {
  read_csv(raw_file, show_col_types = FALSE) |>
    filter(occ2012 == 735, age >= 24, age <= 64, uhours >= 20) |>
    select(earnwke, uhours, age, sex, grade92) |>
    drop_na() |>
    write_csv(extract_file)
}

cps <- read_csv(extract_file, show_col_types = FALSE) |>
  mutate(
    female  = as.integer(sex == 2),
    gender  = factor(if_else(female == 1, "Women", "Men"), levels = c("Men", "Women")),
    college = as.integer(grade92 >= 43),
    edu_cat = factor(
      case_when(grade92 < 43 ~ "No degree", grade92 == 43 ~ "Bachelor", TRUE ~ "Graduate"),
      levels = c("No degree", "Bachelor", "Graduate")
    ),
    age_sq  = age^2
  )
stopifnot(nrow(cps) == 252)

# ---- style --------------------------------------------------------------------
euf_blue <- "#00395B"; euf_teal <- "#1C7F7B"; euf_red <- "#DF5541"
euf_gray <- "#6F6F6F"; euf_rule <- "#D5D5D5"; euf_light <- "#8FBBD9"
gender_cols <- c(Men = euf_blue, Women = euf_red)

theme_euf <- function(base_size = 17) {
  theme_minimal(base_size = base_size, base_family = "Inter") +
    theme(
      text             = element_text(colour = euf_blue),
      axis.text        = element_text(colour = euf_gray),
      axis.title       = element_text(colour = euf_blue),
      plot.title       = element_text(face = "bold", size = rel(1)),
      plot.subtitle    = element_text(colour = euf_gray),
      plot.caption     = element_text(colour = euf_gray, size = rel(0.7), hjust = 0),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(colour = "#EEEEEE"),
      legend.position  = "top",
      legend.justification = "left",
      legend.title     = element_blank(),
      strip.text       = element_text(colour = euf_blue, face = "bold", hjust = 0),
      plot.background  = element_rect(fill = "white", colour = NA)
    )
}
theme_set(theme_euf())

save_fig <- function(plot, name, width = 8, height = 5.2) {
  ggsave(file.path(out_dir, paste0(name, ".png")), plot,
         device = agg_png, width = width, height = height, dpi = 200, bg = "white")
}

usd <- scales::label_dollar(accuracy = 1)
lab_age  <- "Age (years)"
lab_earn <- "Weekly earnings (USD)"
topcode  <- max(cps$earnwke)

# ---- models -------------------------------------------------------------------
m_slr    <- lm(earnwke ~ age, cps)
m_quad   <- lm(earnwke ~ age + age_sq, cps)
m_gap    <- lm(earnwke ~ female, cps)
m_gap_h  <- lm(earnwke ~ female + uhours, cps)
m_aux    <- lm(uhours ~ female, cps)
m_full   <- lm(earnwke ~ female + age + age_sq + uhours + college, cps)
m_edu    <- lm(earnwke ~ female + age + age_sq + uhours + edu_cat, cps)
m_par    <- lm(earnwke ~ age + female, cps)
m_int    <- lm(earnwke ~ age * female, cps)
m_log    <- lm(log(earnwke) ~ female + age + age_sq + uhours + college, cps)
# Model (4): the better-behaved alternative to (3) — log earnings, log hours
m_loglog <- lm(log(earnwke) ~ female + age + age_sq + log(uhours) + college, cps)
m_lnage  <- lm(log(earnwke) ~ age, cps)

# =============================================================================
# Figures
# =============================================================================

# 1. A first look: scatter, top-coding visible ---------------------------------
p_scatter <- ggplot(cps, aes(age, earnwke)) +
  geom_hline(yintercept = topcode, colour = euf_red, linetype = "dashed") +
  geom_point(colour = euf_blue, alpha = 0.55, size = 2.4) +
  annotate("text", x = 64, y = topcode + 110, hjust = 1, colour = euf_red,
           size = 5, family = "Inter",
           label = "Top-coded: 2,885 USD (14 people)") +
  scale_y_continuous(labels = usd, limits = c(0, 3100)) +
  labs(x = lab_age, y = lab_earn)
save_fig(p_scatter, "L10-scatter")

# 2. OLS: line and residuals ---------------------------------------------------
cps_fit <- cps |> mutate(fit = fitted(m_slr))
p_ols <- ggplot(cps_fit, aes(age, earnwke)) +
  geom_segment(aes(xend = age, yend = fit), colour = euf_red, alpha = 0.35) +
  geom_point(colour = euf_blue, alpha = 0.55, size = 2.4) +
  geom_line(aes(y = fit), colour = euf_teal, linewidth = 1.6) +
  scale_y_continuous(labels = usd, limits = c(0, 3100)) +
  labs(x = lab_age, y = lab_earn)
save_fig(p_ols, "L10-ols")

# 2b. The fitted line, without residuals (slide "average association") -------
p_line <- ggplot(cps, aes(age, earnwke)) +
  geom_point(colour = euf_blue, alpha = 0.45, size = 2.4) +
  geom_abline(intercept = coef(m_slr)[[1]], slope = coef(m_slr)[[2]],
              colour = euf_teal, linewidth = 1.8) +
  annotate("label", x = 25, y = 2950, hjust = 0, vjust = 1, colour = euf_teal,
           family = "Inter", fontface = "bold", size = 6, fill = "white", linewidth = 0,
           label = sprintf("predicted earnings = %.0f + %.1f × age",
                           coef(m_slr)[[1]], coef(m_slr)[[2]])) +
  scale_y_continuous(labels = usd, limits = c(0, 3100)) +
  labs(x = lab_age, y = lab_earn)
save_fig(p_line, "L10-line")

# 2c. Data for the least-squares animation (slide "OLS picks the line") -------
# Twelve analysts drawn from the sample: few enough to see every residual.
# The widget (ols-widget.js) rotates a line through the point of means, which
# is the best line for any given slope, and plots the sum of squared
# residuals against the slope.
set.seed(2)
ols_pts <- cps[sample(nrow(cps), 12), c("age", "earnwke")]
m_pts   <- lm(earnwke ~ age, ols_pts)
writeLines(c(
  "// Written by make-figures.R — do not edit by hand.",
  "// Twelve market research analysts (CPS 2014), seed 2.",
  sprintf("window.L10_OLS = {x: [%s], y: [%s], b0: %.4f, b1: %.4f};",
          paste(ols_pts$age, collapse = ", "),
          paste(round(ols_pts$earnwke), collapse = ", "),
          coef(m_pts)[[1]], coef(m_pts)[[2]])
), file.path(out_dir, "L10-ols-data.js"))

# 3. Sampling distribution of the slope (bootstrap) vs the null distribution ---
# Three PNGs with identical size and x-axis: the bootstrap distribution, the
# same with the CI bounds marked (stacked on top as a fragment), and the
# distribution of the slope if H0 were true.
set.seed(2026)
boot_slopes <- replicate(2000, {
  d <- cps[sample(nrow(cps), replace = TRUE), ]
  coef(lm(earnwke ~ age, d))[["age"]]
})
ci     <- confint(m_slr)["age", ]
b_hat  <- coef(m_slr)[["age"]]
se_hat <- coef(summary(m_slr))["age", "Std. Error"]
crit   <- qt(0.975, df.residual(m_slr)) * se_hat
x_lims <- c(-17, 33)
boot_hist <- ggplot(tibble(b = boot_slopes), aes(b)) +
  geom_histogram(binwidth = 1, fill = euf_blue, colour = "white") +
  geom_vline(xintercept = b_hat, colour = euf_teal, linewidth = 1.4) +
  annotate("text", x = b_hat, y = Inf, vjust = 1.4, hjust = -0.08, colour = euf_teal,
           family = "Inter", fontface = "bold", size = 5.5, label = "14.4") +
  scale_x_continuous(limits = x_lims, oob = scales::oob_keep) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(x = "Estimated slope of age (USD per year)", y = "Count",
       title = "Our estimate, resampled 2,000 times")
y_top <- max(table(cut(boot_slopes, seq(-20, 40, 1))))
p_boot_ci <- boot_hist +
  geom_vline(xintercept = ci, colour = euf_red, linetype = "dashed", linewidth = 1) +
  annotate("segment", x = ci[1] - 7, xend = ci[1] - 0.6, y = 0.62 * y_top, yend = 0.62 * y_top,
           colour = euf_red, linewidth = 1.1, arrow = arrow(length = unit(0.25, "cm"), type = "closed")) +
  annotate("segment", x = ci[2] + 7, xend = ci[2] + 0.6, y = 0.62 * y_top, yend = 0.62 * y_top,
           colour = euf_red, linewidth = 1.1, arrow = arrow(length = unit(0.25, "cm"), type = "closed")) +
  annotate("label", x = ci[1] - 7.3, y = 0.62 * y_top, hjust = 1, colour = euf_red,
           family = "Inter", fontface = "bold", size = 5.5, fill = "white", linewidth = 0,
           label = sprintf("%.1f", ci[1])) +
  annotate("label", x = ci[2] + 7.3, y = 0.62 * y_top, hjust = 0, colour = euf_red,
           family = "Inter", fontface = "bold", size = 5.5, fill = "white", linewidth = 0,
           label = sprintf("%.1f", ci[2]))
save_fig(boot_hist, "L10-bootstrap", width = 7, height = 4.2)
save_fig(p_boot_ci, "L10-bootstrap-ci", width = 7, height = 4.2)

null_df <- tibble(b = seq(x_lims[1], x_lims[2], length.out = 500)) |>
  mutate(d = dt(b / se_hat, df.residual(m_slr)) / se_hat)
p_h0 <- ggplot(null_df, aes(b, d)) +
  geom_area(data = filter(null_df, b <= -crit), fill = euf_red, alpha = 0.35) +
  geom_area(data = filter(null_df, b >= crit), fill = euf_red, alpha = 0.35) +
  geom_line(colour = euf_red, linewidth = 1.3) +
  geom_density(data = tibble(b = boot_slopes), aes(b, after_stat(density)),
               inherit.aes = FALSE, colour = euf_blue, linewidth = 1, linetype = "dashed") +
  geom_vline(xintercept = b_hat, colour = euf_teal, linewidth = 1.4) +
  annotate("text", x = 0, y = max(null_df$d) * 1.08, colour = euf_red, family = "Inter",
           fontface = "bold", size = 5.5, label = "if H0: slope = 0") +
  annotate("text", x = 23, y = max(null_df$d) * 0.55, hjust = 0, colour = euf_blue,
           family = "Inter", size = 5, label = "ours\n(resampled)") +
  annotate("text", x = b_hat, y = Inf, vjust = 1.4, hjust = -0.08, colour = euf_teal,
           family = "Inter", fontface = "bold", size = 5.5, label = "14.4") +
  scale_x_continuous(limits = x_lims) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(x = "Estimated slope of age (USD per year)", y = "Density",
       title = "Where estimates would fall if H0 were true")
save_fig(p_h0, "L10-h0", width = 7, height = 4.2)

# 4. Functional form: linear vs quadratic vs smoother ------------------------
grid_age <- tibble(age = 24:64, age_sq = (24:64)^2)
fits <- bind_rows(
  grid_age |> mutate(fit = predict(m_slr,  grid_age), model = "Linear"),
  grid_age |> mutate(fit = predict(m_quad, grid_age), model = "Quadratic")
)
p_form <- ggplot(cps, aes(age, earnwke)) +
  geom_point(colour = euf_blue, alpha = 0.25, size = 2.2) +
  geom_smooth(aes(linetype = "Smoother (loess)"), method = "loess", formula = y ~ x,
              se = FALSE, colour = euf_gray, linewidth = 1.1) +
  geom_line(data = fits, aes(y = fit, colour = model), linewidth = 1.6) +
  scale_colour_manual(values = c(Linear = euf_teal, Quadratic = euf_red)) +
  scale_linetype_manual(values = c("Smoother (loess)" = "dashed")) +
  scale_y_continuous(labels = usd, limits = c(0, 3100)) +
  labs(x = lab_age, y = lab_earn)
save_fig(p_form, "L10-form")

# 4a. Straight line vs age², with the slope of the curve at 30, 45 and 60 --------
b_q <- coef(m_quad)
slope_at <- function(a) b_q[["age"]] + 2 * b_q[["age_sq"]] * a
tang <- tibble(a = c(30, 45, 60)) |>
  mutate(y = predict(m_quad, tibble(age = a, age_sq = a^2)), s = slope_at(a),
         x0 = a - 5, x1 = a + 5, y0 = y - 5 * s, y1 = y + 5 * s,
         lab = sub("-", "\u2212", sprintf("%+.0f", s)))
p_quad <- ggplot(cps, aes(age, earnwke)) +
  geom_point(colour = euf_blue, alpha = 0.22, size = 2.2) +
  geom_line(data = fits, aes(y = fit, colour = model), linewidth = 1.6) +
  geom_segment(data = tang, aes(x = x0, xend = x1, y = y0, yend = y1),
               inherit.aes = FALSE, colour = euf_blue, linewidth = 1.3, linetype = "22") +
  geom_point(data = tang, aes(a, y), inherit.aes = FALSE, colour = euf_blue, size = 3.5) +
  geom_label(data = tang, aes(a, y + 230, label = lab), inherit.aes = FALSE,
             colour = euf_blue, family = "Inter", fontface = "bold", size = 5.5,
             fill = "white", linewidth = 0) +
  scale_colour_manual(values = c(Linear = euf_teal, Quadratic = euf_red),
                      labels = c(Linear = "Straight line: slope 14.4 everywhere",
                                 Quadratic = "With age²: slope changes with age")) +
  guides(colour = guide_legend(nrow = 2)) +
  scale_y_continuous(labels = usd, limits = c(0, 3100)) +
  labs(x = lab_age, y = lab_earn)
save_fig(p_quad, "L10-quad", width = 8, height = 5.6)

# 4b. "Linear in the parameters": one schematic example per case ---------------
set.seed(7)
ff_x <- seq(0.5, 10, length.out = 40)
ff_cases <- list(
  linear    = list(f = function(x) 1 + 0.5 * x,                col = euf_teal),
  quadratic = list(f = function(x) 1 + 1.6 * x - 0.14 * x^2,   col = euf_teal),
  log       = list(f = function(x) exp(0.2 + 0.2 * x),          col = euf_teal),
  nonlinear = list(f = function(x) 1 + x^0.55,                 col = euf_red)
)
for (nm in names(ff_cases)) {
  cs <- ff_cases[[nm]]
  y_true <- cs$f(ff_x)
  noise  <- if (nm == "log") y_true * rnorm(length(ff_x), 0, 0.12) else rnorm(length(ff_x), 0, 0.35)
  p <- ggplot(tibble(x = ff_x, y = y_true + noise), aes(x, y)) +
    geom_point(colour = euf_blue, alpha = 0.45, size = 2.6) +
    geom_line(data = tibble(x = ff_x, y = y_true), colour = cs$col, linewidth = 2) +
    labs(x = "x", y = "y") +
    theme_euf(base_size = 22) +
    theme(axis.text = element_blank(), panel.grid = element_blank(),
          axis.line = element_line(colour = euf_gray))
  save_fig(p, paste0("L10-ff-", nm), width = 4, height = 3.2)
}

# 5. Tukey-Anscombe plots: linear vs quadratic --------------------------------
ta <- bind_rows(
  tibble(fit = fitted(m_slr),  res = resid(m_slr),  model = "Linear in age"),
  tibble(fit = fitted(m_quad), res = resid(m_quad), model = "Quadratic in age")
)
p_ta <- ggplot(ta, aes(fit, res)) +
  geom_hline(yintercept = 0, colour = euf_gray) +
  geom_point(colour = euf_blue, alpha = 0.45, size = 2) +
  geom_smooth(method = "loess", formula = y ~ x, se = FALSE, colour = euf_red, linewidth = 1.3) +
  facet_wrap(~model, scales = "free_x") +
  scale_x_continuous(labels = usd) +
  scale_y_continuous(labels = usd) +
  labs(x = "Fitted values (USD)", y = "Residuals (USD)")
save_fig(p_ta, "L10-tukey-anscombe", width = 10, height = 4.8)
p_ta_lin <- ggplot(filter(ta, model == "Linear in age"), aes(fit, res)) +
  geom_hline(yintercept = 0, colour = euf_gray) +
  geom_point(colour = euf_blue, alpha = 0.45, size = 2.2) +
  geom_smooth(method = "loess", formula = y ~ x, se = FALSE, colour = euf_red, linewidth = 1.5) +
  scale_x_continuous(labels = usd) +
  scale_y_continuous(labels = usd) +
  labs(x = "Fitted values (USD)", y = "Residuals (USD)")
save_fig(p_ta_lin, "L10-ta-linear", width = 7.5, height = 5)

# 6. Logs: distribution of earnings, levels vs logs ------------------------------
# The log axis is centred on the median (dashed), so that the eye can compare
# the two tails: long on the right in levels, much closer to even in logs.
med_lev <- median(cps$earnwke)
med_ln  <- median(log(cps$earnwke))
half_ln <- max(abs(range(log(cps$earnwke)) - med_ln))
p_lev <- ggplot(cps, aes(earnwke)) +
  geom_histogram(binwidth = 120, fill = euf_blue, colour = "white") +
  geom_vline(xintercept = med_lev, colour = euf_red, linetype = "dashed", linewidth = 1) +
  scale_x_continuous(labels = usd) +
  labs(x = lab_earn, y = "Count", title = "Levels")
p_ln <- ggplot(cps, aes(log(earnwke))) +
  geom_histogram(binwidth = 0.16, fill = euf_teal, colour = "white") +
  geom_vline(xintercept = med_ln, colour = euf_red, linetype = "dashed", linewidth = 1) +
  scale_x_continuous(limits = med_ln + c(-1, 1) * half_ln * 1.03, oob = scales::oob_keep) +
  labs(x = "ln(weekly earnings)", y = NULL, title = "Logs")
save_fig(p_lev + p_ln, "L10-logs", width = 10, height = 4.6)

# 7. The raw gap and what lies behind it ---------------------------------------
means <- cps |> group_by(gender) |> summarise(earnwke = mean(earnwke), uhours = mean(uhours))
p_gap_e <- ggplot(cps, aes(gender, earnwke, colour = gender)) +
  geom_jitter(width = 0.18, height = 0, alpha = 0.4, size = 2) +
  geom_point(data = means, size = 7, shape = 18) +
  geom_label(data = means, aes(label = usd(earnwke)), nudge_x = 0.42, size = 5.5,
             family = "Inter", fontface = "bold", fill = "white", linewidth = 0) +
  scale_x_discrete(expand = expansion(add = c(0.5, 0.9))) +
  scale_colour_manual(values = gender_cols, guide = "none") +
  scale_y_continuous(labels = usd) +
  labs(x = NULL, y = lab_earn, title = "Weekly earnings")
p_gap_h <- ggplot(cps, aes(gender, uhours, colour = gender)) +
  geom_jitter(width = 0.18, height = 0.4, alpha = 0.4, size = 2) +
  geom_point(data = means, size = 7, shape = 18) +
  geom_label(data = means, aes(label = sprintf("%.1f h", uhours)), nudge_x = 0.42,
             size = 5.5, family = "Inter", fontface = "bold", fill = "white", linewidth = 0) +
  scale_x_discrete(expand = expansion(add = c(0.5, 0.9))) +
  scale_colour_manual(values = gender_cols, guide = "none") +
  labs(x = NULL, y = "Usual hours per week", title = "Hours worked")
save_fig(p_gap_e + p_gap_h, "L10-gap", width = 10, height = 4.8)
# Same size, hours panel left empty: shown first, L10-gap fades in on top
save_fig(p_gap_e + plot_spacer(), "L10-gap-earn", width = 10, height = 4.8)

# 8. Parallel slopes vs interaction model (ModernDive terminology) --------------
grid_g <- expand_grid(age = 24:64, female = 0:1) |>
  mutate(gender = factor(if_else(female == 1, "Women", "Men"), levels = c("Men", "Women")))
pl <- bind_rows(
  grid_g |> mutate(fit = predict(m_par, grid_g), model = "Parallel slopes: age + female"),
  grid_g |> mutate(fit = predict(m_int, grid_g), model = "Interaction: age × female")
) |> mutate(model = fct_inorder(model))
p_int <- ggplot(cps, aes(age, earnwke, colour = gender)) +
  geom_point(alpha = 0.3, size = 1.8) +
  geom_line(data = pl, aes(y = fit), linewidth = 1.6) +
  facet_wrap(~model) +
  scale_colour_manual(values = gender_cols) +
  scale_y_continuous(labels = usd, limits = c(0, 3100)) +
  labs(x = lab_age, y = lab_earn)
save_fig(p_int, "L10-interaction", width = 10, height = 5)

# 8b. Plot, do not read: the predicted gap by age, with its 95% CI -------------
# gap(a) = b_female + b_int * a; its variance from the coefficient covariance.
V <- vcov(m_int)
gap_df <- tibble(age = 24:64) |>
  mutate(gap = coef(m_int)[["female"]] + coef(m_int)[["age:female"]] * age,
         se  = sqrt(V["female", "female"] + age^2 * V["age:female", "age:female"] +
                      2 * age * V["female", "age:female"]),
         lo  = gap - qt(0.975, df.residual(m_int)) * se,
         hi  = gap + qt(0.975, df.residual(m_int)) * se)
p_gapage <- ggplot(gap_df, aes(age, gap)) +
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = euf_light, alpha = 0.45) +
  geom_hline(yintercept = 0, colour = euf_gray) +
  geom_line(colour = euf_red, linewidth = 1.8) +
  annotate("text", x = 25, y = 280, hjust = 0, colour = euf_gray, family = "Inter",
           size = 5, label = "95% confidence band") +
  scale_y_continuous(labels = usd) +
  labs(x = lab_age, y = "Predicted gap, women − men (USD)")
save_fig(p_gapage, "L10-gap-by-age", width = 7, height = 5.2)

# 8c. Data for the animated "one line misses the groups" figure ---------------
# groups-widget.js draws all 252 analysts, the pooled line (grey) and the
# parallel slopes lines (blue, red), which slide out of the grey line.
writeLines(c(
  "// Written by make-figures.R — do not edit by hand.",
  "// All 252 analysts (CPS 2014); pooled OLS and the parallel slopes model.",
  sprintf("window.L10_GROUPS = {age: [%s], earn: [%s], female: [%s], pooled: [%.3f, %.3f], par: [%.3f, %.3f, %.3f]};",
          paste(cps$age, collapse = ","), paste(round(cps$earnwke), collapse = ","),
          paste(cps$female, collapse = ","),
          coef(m_slr)[[1]], coef(m_slr)[[2]],
          coef(m_par)[["(Intercept)"]], coef(m_par)[["age"]], coef(m_par)[["female"]])
), file.path(out_dir, "L10-groups-data.js"))

# 9. Three kinds of interaction (schematic, no data) ---------------------------
sch_theme <- theme(axis.text = element_blank(), panel.grid = element_blank(),
                   axis.line = element_line(colour = euf_gray))
s1 <- tibble(x = factor(c("Z = 0", "Z = 1", "Z = 0", "Z = 1"), levels = c("Z = 0", "Z = 1")),
             g = c("D = 0", "D = 0", "D = 1", "D = 1"), y = c(2.4, 3.2, 2.0, 1.9)) |>
  ggplot(aes(x, y, colour = g, group = g)) +
  geom_line(linewidth = 1.4) + geom_point(size = 4) +
  scale_colour_manual(values = c(euf_blue, euf_red)) +
  labs(title = "Dummy × dummy", subtitle = "the gap differs by group",
       x = "Z (binary)", y = "y") + sch_theme
s2 <- tibble(x = rep(c(0, 1), 2), g = rep(c("D = 0", "D = 1"), each = 2),
             y = c(1, 2.2, 1.3, 3.6)) |>
  ggplot(aes(x, y, colour = g)) + geom_line(linewidth = 1.4) +
  scale_colour_manual(values = c(euf_blue, euf_red)) +
  labs(title = "Dummy × continuous", subtitle = "slopes differ by group",
       x = "X (continuous)", y = NULL) + sch_theme
s3 <- tibble(x = rep(c(0, 1), 3), g = rep(c("Z low", "Z mid", "Z high"), each = 2),
             y = c(1, 1.5, 1.1, 2.4, 1.2, 3.3)) |>
  mutate(g = fct_inorder(g)) |>
  ggplot(aes(x, y, colour = g)) + geom_line(linewidth = 1.4) +
  scale_colour_manual(values = c(euf_light, euf_teal, euf_blue)) +
  labs(title = "Continuous × continuous", subtitle = "slope of X changes with Z",
       x = "X (continuous)", y = NULL) + sch_theme
save_fig(s1 + s2 + s3, "L10-interaction-types", width = 12, height = 4.6)

# 10. Diagnostics of the final model ---------------------------------------------
diag <- tibble(fit = fitted(m_full), res = resid(m_full))
d1 <- ggplot(diag, aes(fit, res)) +
  geom_hline(yintercept = 0, colour = euf_gray) +
  geom_point(colour = euf_blue, alpha = 0.45, size = 2) +
  geom_smooth(method = "loess", formula = y ~ x, se = FALSE, colour = euf_red, linewidth = 1.2) +
  scale_x_continuous(labels = usd) + scale_y_continuous(labels = usd) +
  labs(x = "Fitted values (USD)", y = "Residuals (USD)", title = "Residuals vs fitted")
d2 <- ggplot(diag, aes(sample = res)) +
  stat_qq(colour = euf_blue, alpha = 0.5, size = 2) +
  stat_qq_line(colour = euf_red, linewidth = 1.1) +
  labs(x = "Theoretical quantiles", y = "Sample quantiles", title = "Normal Q-Q")
save_fig(d1 + d2, "L10-diagnostics", width = 10, height = 4.8)

# 10b. Diagnostics of model (4): log earnings, log hours ------------------------
diag4 <- tibble(fit = fitted(m_loglog), res = resid(m_loglog))
d41 <- ggplot(diag4, aes(fit, res)) +
  geom_hline(yintercept = 0, colour = euf_gray) +
  geom_point(colour = euf_teal, alpha = 0.5, size = 2) +
  geom_smooth(method = "loess", formula = y ~ x, se = FALSE, colour = euf_red, linewidth = 1.2) +
  labs(x = "Fitted values (log USD)", y = "Residuals (log USD)", title = "Residuals vs fitted")
d42 <- ggplot(diag4, aes(sample = res)) +
  stat_qq(colour = euf_teal, alpha = 0.6, size = 2) +
  stat_qq_line(colour = euf_red, linewidth = 1.1) +
  labs(x = "Theoretical quantiles", y = "Sample quantiles", title = "Normal Q-Q")
save_fig(d41 + d42, "L10-diagnostics-log", width = 10, height = 4.8)

# =============================================================================
# Numbers quoted on the slides
# =============================================================================
r <- function(m, term, d = 1) round(coef(m)[[term]], d)
se <- function(m, term, d = 1) round(coef(summary(m))[term, "Std. Error"], d)
cat("\n---- numbers for the slides ----\n")
cat("n =", nrow(cps), "| women =", sum(cps$female), "| top-coded at", topcode,
    "(", sum(cps$earnwke == topcode), "people )\n")
cat("SLR: b0 =", r(m_slr, "(Intercept)"), " b1 =", r(m_slr, "age"), " SE =", se(m_slr, "age"),
    " t =", round(coef(summary(m_slr))["age", "t value"], 2),
    " 95% CI =", round(ci, 1), " R2 =", round(summary(m_slr)$r.squared, 3), "\n")
cat("Bootstrap SD of slope =", round(sd(boot_slopes), 1), "\n")
cat("Quadratic: b1 =", r(m_quad, "age"), " b2 =", r(m_quad, "age_sq", 3),
    " peak at", round(-coef(m_quad)[["age"]] / (2 * coef(m_quad)[["age_sq"]]), 1),
    " R2 =", round(summary(m_quad)$r.squared, 3), "\n")
cat("Slope of quadratic at 30 / 45 / 60:",
    round(coef(m_quad)[["age"]] + 2 * coef(m_quad)[["age_sq"]] * c(30, 45, 60), 1), "\n")
cat("Raw gap =", r(m_gap, "female"), "(SE", se(m_gap, "female"), ") intercept =", r(m_gap, "(Intercept)"), "\n")
cat("R2 raw-gap model =", round(summary(m_gap)$r.squared, 3),
    " | gap-with-hours model: SE female =", se(m_gap_h, "female"), " SE hours =", se(m_gap_h, "uhours"),
    " R2 =", round(summary(m_gap_h)$r.squared, 3), "\n")
cat("Gap | hours =", r(m_gap_h, "female"), " b_hours =", r(m_gap_h, "uhours"),
    " delta (hours ~ female) =", r(m_aux, "female", 2),
    " => b_hours * delta =", round(coef(m_gap_h)[["uhours"]] * coef(m_aux)[["female"]], 1), "\n")
cat("Full model:\n"); print(round(coef(summary(m_full)), 3))
cat("R2 full =", round(summary(m_full)$r.squared, 3), " adj =", round(summary(m_full)$adj.r.squared, 3), "\n")
cat("Education model:\n"); print(round(coef(summary(m_edu)), 1))
cat("Parallel slopes:\n"); print(round(coef(summary(m_par)), 1))
cat("Interaction:\n"); print(round(coef(summary(m_int)), 1))
cat("Slope men =", r(m_int, "age"), " slope women =", round(coef(m_int)[["age"]] + coef(m_int)[["age:female"]], 1), "\n")
cat("Gap at 30 / 50:", round(coef(m_int)[["female"]] + coef(m_int)[["age:female"]] * c(30, 50), 0), "\n")
cat("Log model:\n"); print(round(coef(summary(m_log)), 4))
cat("exp(b)-1: college =", round(exp(coef(m_log)[["college"]]) - 1, 3),
    " female =", round(exp(coef(m_log)[["female"]]) - 1, 3),
    " uhours =", round(exp(coef(m_log)[["uhours"]]) - 1, 3), "\n")
cat("Log earnings on age: b =", round(coef(m_lnage)[["age"]], 4), "\n")
skew <- function(x) mean((x - mean(x))^3) / sd(x)^3
cat("Model (4), log earnings + log hours:\n"); print(round(coef(summary(m_loglog)), 4))
cat("R2 (4) =", round(summary(m_loglog)$r.squared, 3),
    " | residual skewness (3) =", round(skew(resid(m_full)), 2), " (4) =", round(skew(resid(m_loglog)), 2), "\n")
cat("Robust (HC1) SE of female in (4):",
    round(sqrt(sandwich::vcovHC(m_loglog, type = "HC1")["female", "female"]), 4), "\n")
tob <- AER::tobit(log(earnwke) ~ female + age + age_sq + log(uhours) + college,
                  right = log(topcode), data = cps)
cat("Tobit (top-coding as censoring), female:", round(coef(tob)[["female"]], 4), "\n")
cat("Group means:\n"); print(cps |> group_by(gender) |> summarise(n = n(), earn = mean(earnwke), hours = mean(uhours), college = mean(college)))
