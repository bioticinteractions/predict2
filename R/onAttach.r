.onAttach <- function(libname, pkgname) {
  # Runs when attached to search() path such as by library() or require()
  if (interactive()) {
    v = packageVersion("predict2")
    # d = read.dcf(system.file("DESCRIPTION", package="data.table"), fields = c("Packaged", "Built"))
    # if(is.na(d[1])){
    #   if(is.na(d[2])){
    #     return() #neither field exists
    #   } else{
    #     d = unlist(strsplit(d[2], split="; "))[3]
    #   }
    # } else {
    #   d = d[1]
    # }
    # dev = as.integer(v[1,3])%%2 == 1  # version number odd => dev
    # packageStartupMessage("data.table ", v, if(dev) paste0(" IN DEVELOPMENT built ", d))
    # if (dev && (Sys.Date() - as.Date(d))>28)
      # packageStartupMessage("**********\nThis development version of data.table was built more than 4 weeks ago. Please update.\n**********")
    # if (!.Call(ChasOpenMP))
      # packageStartupMessage("**********\nThis installation of data.table has not detected OpenMP support. It will still work but in single-threaded mode. If this a Mac and you obtained the Mac binary of data.table from CRAN, CRAN's Mac does not yet support OpenMP. In the meantime please follow our Mac installation instructions on the data.table homepage. If it works and you observe benefits from multiple threads as others have reported, please convince Simon Ubanek by sending him evidence and ask him to turn on OpenMP support when CRAN builds package binaries for Mac. Alternatives are to install Ubuntu on your Mac (which I have done and works well) or use Windows where OpenMP is supported and works well.\n**********")
    packageStartupMessage('  This is a function created by Daniel Song to improve workflow within R when using multiple models to make predictions.')
    packageStartupMessage('  This was tested with regresssion models but should work with classification models.')
    packageStartupMessage('  See ?predict2 for notes and tips that are likely to be of no use to you.')
  }
}
