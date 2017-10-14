# subset sas data
# sas_n = names(grocery)
# sas_n = sas_n[grepl('^t.*', sas_n, perl = T)]
# trfm_sas = subset(grocery, select = sas_n)
# sas_t_n = names(trfm_sas)
# sas_t_n = gsub('^t(.*)','\\1_trfm',  sas_t_n)
# names(trfm_sas) = sas_t_n
#
# # subset dan data
# trfm_dan = trfm_data
#
# # check true or false equality
# check_list = vector('list', length = ncol(trfm_data))
# names_list = names(trfm_sas)
# for (i in 1:length(check_list)) {
#   trfm_sas_var = round(trfm_sas[[names_list[i]]], 5)
#   trfm_dan_var = round(trfm_dan[[names_list[i]]], 5)
#   check_list[[i]] = table(trfm_sas_var == trfm_dan_var)
# }
