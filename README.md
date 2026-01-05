# NBA Scoring Streaks: Exploratory Analysis and Formal Inference

## Overview

Scoring streaks are a deeply ingrained concept in basketball discourse. Players are often described as being “hot” or “cold,” and these narratives frequently influence fan expectations, media coverage, and even betting markets. Intuitively, one might expect regression to the mean following extended streaks—long scoring over-performances followed by under-performances, and vice versa.

This project rigorously evaluates whether such intuitions hold up under statistical scrutiny. Using game-level NBA data and player-specific baselines, we examine whether scoring streaks meaningfully affect next-game performance once uncertainty and player heterogeneity are properly accounted for.

The goal of this study is **not** to establish causality or to build a predictive model, but rather to test whether streak-conditioned performance differs in a statistically meaningful way from baseline behavior.

---

## Key Questions

This analysis is structured around two related questions:

1. **Global Effect**  
   Do scoring streaks, on average, change a player’s probability of exceeding their typical scoring performance in the next game?

2. **Conditional Effects**  
   If an effect exists, does it depend on:
   - streak direction (over vs. under)
   - streak length (short vs. extended streaks)?

---

## Methodology

### Data Preparation
- Game-level player scoring data were collected for a full NBA season.
- Analysis was restricted to **high-usage players** to reduce noise from low-volume scorers.
- Player-specific baselines were defined using rolling season-average scoring thresholds.
- All streak features were constructed using **only prior game information** to avoid outcome leakage.

### Exploratory Analysis
Initial exploratory analysis examined:
- streak frequency distributions
- player-level streak behavior
- apparent streak-related patterns in over- and under-performance

While some patterns appeared visually compelling at this stage, exploratory analysis alone was insufficient to distinguish signal from noise.

### Formal Hypothesis Testing
To rigorously evaluate streak effects, we conducted formal statistical inference:

- **Player-level baseline comparison**  
  For each player, we computed the difference between streak-conditioned over-performance probability and baseline probability.

- **Global inference**
  - One-sample t-test on player-level deviations
  - Nonparametric bootstrap confidence interval

- **Stratified inference**
  - Separate tests by streak direction and length
  - Player-level aggregation to preserve independence
  - Results interpreted as exploratory conditional analyses

---

## Results

### Global Findings
- The average player-level deviation from baseline following scoring streaks is **near zero**.
- A one-sample t-test fails to reject the null hypothesis of no effect.
- A bootstrap confidence interval for the mean deviation comfortably includes zero.
- Effect sizes are extremely small (on the order of 1 percentage point or less).

### Conditional Findings
- Stratified analyses by streak direction and length show **no consistent or monotonic patterns**.
- Nearly all conditional tests are statistically non-significant.
- An isolated nominally significant result for short under-streaks is not robust across bins and is likely attributable to random variation.

### Interpretation
Despite intuitive expectations of regression to the mean, scoring streaks do **not** appear to systematically alter next-game scoring outcomes once player-specific baselines and uncertainty are properly accounted for. Performance remains approximately symmetric around baseline rates across players and streak conditions.

---

## Conclusions

This study finds no evidence that scoring streaks, when considered in isolation, provide reliable predictive signal for next-game scoring performance among high-usage NBA players. Apparent streak-related patterns observed in exploratory analysis largely disappear under formal statistical testing.

These results highlight the importance of:
- player-level baselines
- careful aggregation
- explicit uncertainty quantification

They also caution against over-reliance on streak-based heuristics in analytical or decision-making contexts.

---

## Limitations and Future Extensions

While streaks alone show limited explanatory power, several natural extensions could be explored:

- **Contextual confounders**  
  Incorporating opponent defensive strength, pace, home/away effects, rest days, injuries, and lineup changes.

- **Richer baselines**  
  Modeling baseline performance using minutes, usage rate, and role changes rather than season averages alone.

- **Interaction effects**  
  Evaluating whether streak indicators interact with contextual features in a multivariate setting.

- **Predictive modeling**  
  Testing whether streak-related features contribute marginal value when included alongside broader contextual variables in supervised models.

---

## Final Notes

A key takeaway from this project is that intuitively appealing narratives do not always translate into statistically robust signals. Negative results, when obtained through careful methodology and formal inference, are informative and valuable. This study demonstrates how exploratory insights can—and should—be validated through disciplined statistical reasoning.

## Technical Implementation

This project was implemented using a modular, notebook-driven data science workflow, with an emphasis on reproducibility, correctness, and statistical rigor.

### Data Processing and Feature Engineering

- **Data Source:**  
  Game-level NBA player statistics were ingested from structured data tables and processed using SQL and Python.

- **SQL-Based Feature Construction:**  
  SQL was used to construct game-level features efficiently, including:
  - player and game identifiers
  - rolling season averages
  - initial streak identifiers
  - filtering to high-usage players  
  Window functions were leveraged to compute rolling statistics and to ensure consistent season-level baselines prior to analysis.

- **Temporal Integrity:**  
  All streak-related features were constructed using **lagged information only**, ensuring that streak direction and streak length reflected the player’s state *entering* each game. This prevented outcome leakage and preserved causal ordering in the analysis.

---

### Python Analytics Stack

The core analysis was conducted in Python using the following libraries:

- **pandas** for data manipulation, grouping, and feature annotation
- **NumPy** for vectorized numerical operations and resampling
- **SciPy** for classical statistical tests (e.g., one-sample t-tests)
- **matplotlib / seaborn** for exploratory and explanatory visualizations

Player-level baselines were computed using `groupby` and `transform` operations, enabling efficient annotation of game-level data while preserving row-level granularity.

---

### Statistical Inference

Formal hypothesis testing was implemented at the **player level**, rather than the game level, to avoid inflating sample sizes and to properly account for player heterogeneity.

Key inference techniques included:

- **One-sample t-tests**  
  Used to evaluate whether the mean player-level deviation from baseline differed from zero under standard normality assumptions.

- **Bootstrap confidence intervals**  
  Implemented via repeated resampling of player-level deviations to estimate uncertainty in the mean without strong distributional assumptions.

- **Stratified analyses**  
  Conditional tests by streak direction and streak length were conducted using player-level aggregation to preserve independence across observations.

All hypothesis tests were framed to quantify uncertainty and assess statistical distinguishability from baseline behavior rather than to establish causality.

---

### Visualization and Diagnostics

Visualizations were designed primarily for **interpretability and validation**, rather than pattern discovery. Key plots included:

- Distribution plots of player-level deviations from baseline
- Boxplots comparing streak-conditioned effects across bins
- Scatter plots examining heterogeneity and baseline dependence

Reference lines and consistent scaling were used to facilitate comparison across conditions.

---

### Reproducibility and Organization

- The analysis is organized into sequential notebooks corresponding to:
  1. Data extraction and processing
  2. Exploratory analysis
  3. Formal inference and hypothesis testing
- Each notebook is designed to run independently after data preparation.
- Intermediate datasets are stored explicitly to support reproducibility and inspection.

---

### Design Philosophy

Throughout the project, the following principles guided implementation:

- **Baseline-first analysis:**  
  All comparisons were anchored to player-specific baselines to control for skill and usage differences.

- **Aggregation before inference:**  
  Player-level aggregation was used prior to hypothesis testing to maintain valid statistical assumptions.

- **Separation of concerns:**  
  Exploratory analysis, formal inference, and visualization were treated as distinct stages, each with different goals and standards of evidence.

This technical approach ensures that conclusions are driven by statistically defensible analysis rather than artifacts of data processing or aggregation.
