#' Toy data that makes no sense
#'
#' @description Data arbitrarily created using:
#' \preformatted{
#'  set.seed(333)
#'  lm_data = setNames(as.data.frame(runif(50, min = 0, max = 50)), 'y')
#'  lm_data$x = lm_data$y + 1
#' }
#' @docType data
#' @usage data(lm_data)
#' @keywords datasets
#' @examples
#' data(lm_data)
#' df_train = lm_data[1:25, ]
#' df_test = lm_data[26:50, ]
#'
#' lm_int = lm(y ~ x, data = df_train)
#' lm_noint = lm(y ~ 0 + x, data = df_train)
#' list_lm = c('lm_int', 'lm_noint')
#'
#' predicted = predict2(
#'   model = list_lm,
#'   newdata = df_test,
#'   actual = df_test$y,
#'   pred_type = 'response',
#'   write_model = FALSE,
#'   write_pred = FALSE,
#'   csv_name = 'none'
#' )
#' head(predicted)
"lm_data"
