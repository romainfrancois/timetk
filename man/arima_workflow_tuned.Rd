% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data-arima_workflow_tuned.R
\docType{data}
\name{arima_workflow_tuned}
\alias{arima_workflow_tuned}
\title{Example ARIMA Tuning Results}
\format{
An object of class \code{tune_results} (inherits from \code{time_series_cv}, \code{rset}, \code{tbl_df}, \code{tbl}, \code{data.frame}) with 2 rows and 4 columns.
}
\usage{
arima_workflow_tuned
}
\description{
These objects are the results of an analysis of the
M750 data set, which came from the M4 Forecast Competition.
}
\details{
The code used to generate the data:\preformatted{library(tidyverse)
library(parsnip)
library(rsample)
library(recipes)
library(tune)
library(dials)
library(yardstick)
library(workflows)
library(modeltime)
library(timetk)

# DATA ----
m750 <- m4_monthly \%>\% filter(id == "M750")

# RESAMPLE SPEC ----
resample_spec <- time_series_cv(data = m750,
                                initial     = "6 years",
                                assess      = "2 years",
                                skip        = "2 years",
                                cumulative  = FALSE,
                                slice_limit = 2)

# ARIMA SPEC ----
model_spec <- arima_reg(
    period = 12,
    p = tune(), d = tune(), q = tune(),
    P = tune(), D = tune(), Q = tune()
) \%>\%
    set_engine("forecast")

# RECIPE SPEC ----
recipe_spec <- recipe(value ~ date, data = m750)

# GRID SPEC ----
arima_params <- parameters(p(), d(), q(), P(), D(), Q())

set.seed(3)
arima_grid <- grid_latin_hypercube(arima_params, size = 50)


# HYPER PARAMETER TUNING ----
arima_workflow_tuned <- workflow() \%>\%
    add_recipe(recipe_spec) \%>\%
    add_model(model_spec) \%>\%
    tune_grid(
        resamples = resample_spec,
        grid      = arima_grid,
        metrics   = metric_set(mae, mape, smape, mase, rmse, rsq),
        control   = control_grid(verbose = TRUE)
    )
}
}
\examples{
arima_workflow_tuned

}
\keyword{datasets}
