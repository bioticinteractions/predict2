library(data.table)
library(predict2)

final_data = fread('~/cloud/google_drive/trans/sales_forecasting/august3/20170929/sas_out/data_sept_final.csv', stringsAsFactors = F)
table(final_data$category_o)

hk_tran = read.csv('~/cloud/google_drive/Sales Prediction Model/Models/homekitchen/ranks_plots_variables_homekitchen.csv', stringsAsFactors = F)
hk_tran = read.csv('~/cloud/google_drive/trans/sales_forecasting/grocery/ranks_plots_variables_grocery.csv', stringsAsFactors = F)

hk_data = subset(final_data, category_o == 'Home & Kitchen')
hk_data = fread('~/cloud/google_drive/trans/sales_forecasting/prod_mod/test_1/finaldata_r.csv', stringsAsFactors = F)
hk_data = hk_data[hk_data$category_o == 'Grocery', ]

dan = trfm_auto(
  trfm_df = hk_tran,
  data_df = hk_data,
  variable_col = 'variable',
  min_col = 'min',
  max_col = 'max',
  zero_value_col = 'zero_value',
  missing_col = 'missing',
  transformation_col = 'transformation',
  keep_col = 'keep'
)

hk_data_sas = fread('~/cloud/google_drive/trans/sales_forecasting/august3/20170929/sas_out/data_sept_homekitchen.csv', stringsAsFactors = F)

t_names = names(hk_data_sas)
names_trfm = gsub('^t(.*)$', '\\1_trfm', t_names)
names(hk_data_sas) = names_trfm

# round and compare
temp = vector('list')
round_int = 6
for (i in names(dan)) {
  data_round_sas = round(hk_data_sas[[i]], round_int)
  data_round_dan = round(dan[[i]], round_int)
  temp[[i]] = table(data_round_sas == data_round_dan)
}
temp

col_i = 'avg_rank_l15_trfm'
col_o = gsub('(.*)_trfm', '\\1', col_i)

hk_tran
manual_trfm = with(hk_data, trfm(get(col_o), min = 1, max = 4111, zero = 0, missing = 473, transformation = 2))

temp_2 = setDT(cbind.data.frame(hk_data_sas[[col_o]], hk_data_sas[[col_i]], dan[[col_i]]))
names(temp_2) = c('untransformed', 'sas', 'dan')
head(temp_2)

temp_2$sas_round = round(temp_2$sas, round_int)
temp_2$dan_round = round(temp_2$dan, round_int)
temp_2$check_round = with(temp_2, sas_round ==  dan_round)
temp_2$check_raw = with(temp_2, signif(sas, round_int) == signif(dan, round_int))
temp_2[temp_2$check_round == F, ]
temp_2[temp_2$check_raw == F, ]
table(temp_2$sas_round - temp_2$dan_round)
table(temp_2$sas - temp_2$dan)
