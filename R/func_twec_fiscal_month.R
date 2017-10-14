#' Takes predictions from model object(s) and and combines it with actual values
#' This function takes a vector of strings that represent the model object names
#' @param month A vector or data column containig date (either as a Date class or character). Must be in the format of YYYY-MM-DD (either as.Date format or character)
#' @return twec_fiscal_month() will return a vector of integers representing the fiscal year month designations for TWEC
#' @export
#' @examples
#' library(predict2)
#'
#' # example with vector containing character
#' date_vec = c('2017-01-30', '2017-12-21')
#' twec_fiscal_month(date_vec)
#'
#' # example with a data frame already as.Date format
#' date_df = setNames(data.frame(c('2017-01-30', '2017-04-05', '2017-12-26')), c('date'))
#' date_df$date = as.Date(date_df$date, format = '%Y-%m-%d')
#' str(date_df)
#' twec_fiscal_month(date_df$date)

twec_fiscal_month = function(month) {
  month = as.character(month)

  month[month >= '2017-01-29' & month <= '2017-02-04'] = 2
  month[month >= '2017-02-05' & month <= '2017-02-11'] = 2
  month[month >= '2017-02-12' & month <= '2017-02-18'] = 2
  month[month >= '2017-02-19' & month <= '2017-02-25'] = 2
  month[month >= '2017-02-26' & month <= '2017-03-04'] = 3
  month[month >= '2017-03-05' & month <= '2017-03-11'] = 3
  month[month >= '2017-03-12' & month <= '2017-03-18'] = 3
  month[month >= '2017-03-19' & month <= '2017-03-25'] = 3
  month[month >= '2017-03-26' & month <= '2017-04-01'] = 4
  month[month >= '2017-04-02' & month <= '2017-04-08'] = 4
  month[month >= '2017-04-09' & month <= '2017-04-15'] = 4
  month[month >= '2017-04-16' & month <= '2017-04-22'] = 4
  month[month >= '2017-04-23' & month <= '2017-04-29'] = 4
  month[month >= '2017-04-30' & month <= '2017-05-06'] = 5
  month[month >= '2017-05-07' & month <= '2017-05-13'] = 5
  month[month >= '2017-05-14' & month <= '2017-05-20'] = 5
  month[month >= '2017-05-21' & month <= '2017-05-27'] = 5
  month[month >= '2017-05-28' & month <= '2017-06-03'] = 6
  month[month >= '2017-06-04' & month <= '2017-06-10'] = 6
  month[month >= '2017-06-11' & month <= '2017-06-17'] = 6
  month[month >= '2017-06-18' & month <= '2017-06-24'] = 6
  month[month >= '2017-06-25' & month <= '2017-07-01'] = 7
  month[month >= '2017-07-02' & month <= '2017-07-08'] = 7
  month[month >= '2017-07-09' & month <= '2017-07-15'] = 7
  month[month >= '2017-07-16' & month <= '2017-07-22'] = 7
  month[month >= '2017-07-23' & month <= '2017-07-29'] = 7
  month[month >= '2017-07-30' & month <= '2017-08-05'] = 8
  month[month >= '2017-08-06' & month <= '2017-08-12'] = 8
  month[month >= '2017-08-13' & month <= '2017-08-19'] = 8
  month[month >= '2017-08-20' & month <= '2017-08-26'] = 8
  month[month >= '2017-08-27' & month <= '2017-09-02'] = 9
  month[month >= '2017-09-03' & month <= '2017-09-09'] = 9
  month[month >= '2017-09-10' & month <= '2017-09-16'] = 9
  month[month >= '2017-09-17' & month <= '2017-09-23'] = 9
  month[month >= '2017-09-24' & month <= '2017-09-30'] = 10
  month[month >= '2017-10-01' & month <= '2017-10-07'] = 10
  month[month >= '2017-10-08' & month <= '2017-10-14'] = 10
  month[month >= '2017-10-15' & month <= '2017-10-21'] = 10
  month[month >= '2017-10-22' & month <= '2017-10-28'] = 10
  month[month >= '2017-10-29' & month <= '2017-11-04'] = 11
  month[month >= '2017-11-05' & month <= '2017-11-11'] = 11
  month[month >= '2017-11-12' & month <= '2017-11-18'] = 11
  month[month >= '2017-11-19' & month <= '2017-11-25'] = 11
  month[month >= '2017-11-26' & month <= '2017-12-02'] = 12
  month[month >= '2017-12-03' & month <= '2017-12-09'] = 12
  month[month >= '2017-12-10' & month <= '2017-12-16'] = 12
  month[month >= '2017-12-17' & month <= '2017-12-23'] = 12
  month[month >= '2017-12-24' & month <= '2017-12-30'] = 12
  month[month >= '2017-12-31' & month <= '2018-01-06'] = 1
  month[month >= '2018-01-07' & month <= '2018-01-13'] = 1
  month[month >= '2018-01-14' & month <= '2018-01-20'] = 1
  month[month >= '2018-01-21' & month <= '2018-01-27'] = 1
  month[month >= '2018-01-28' & month <= '2018-02-03'] = 1

  return(as.numeric(month))
}
