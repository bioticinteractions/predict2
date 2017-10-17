# predict2
Predict2 is a suite of function that makes comparing the results of multiple predictive models easier.

The functions in this library will allow a user to:

- automatically save the predictions of multiple model objects along with the actual model objects
- automatically transform data based on user-values
- compare multiple models

The common situation I find myself is testing/validating multiple models. With predict2() I can train and fit models multiple models (e.g. different parameters for randomforest models or GBM models) and save the predictions along with the 'actual/expected/test' data to calculate gini coefficients or ROC curves.
