.onAttach <- function(libname, pkgname) {
  # Runs when attached to search() path such as by library() or require()
  if (interactive()) {
    v = utils::packageVersion("predict2")
    packageStartupMessage('  This is a function created by Daniel Song to improve workflow')
    packageStartupMessage('  within R when using multiple models to make predictions.')
    packageStartupMessage('  This was tested with regresssion models but should work with classification models.')
    packageStartupMessage('  See ?predict2 for notes and tips that are likely to be of no use to you.')
  }
}
