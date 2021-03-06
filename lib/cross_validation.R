########################
### Cross Validation ###
########################

### Authors: Grp 1 
### Project 3
### ADS Fall 2017


cv.function <- function(X.train, y.train, d, K,
                        cv.svm = F, cv.gbm = F, cv.rf = F,
                        cv.lda = F){
  
  # to debug
  #X.train <- dat_train
  #y.train <- label_train
  #d = 0.5
  #cv.rf = T

  
  n <- length(y.train[,2])
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error <- rep(NA, K)
  
  for (i in 1:K){
    train.data <- X.train[s != i,]
    train.label <- y.train[s != i,]
    test.data <- X.train[s == i,]
    test.label <- y.train[s == i,]
    print('train.data:')
    print(dim(train.data))
    
    ## cross validate to GBM model
    if( cv.gbm ){
      
      params<-list(shrinkage=d)
      fit <- train(train.data, train.label, params, run.gbm = TRUE)
      pred <- test(fit, test.data, test.gbm = T)
      
    }
    
    ## cross validate to SVM model
    if( cv.svm ){
      params <- list(gamma=d)
      fit <- train(train.data, train.label, params, run.svm = TRUE)
      
      pred <- test(fit, test.data, test.svm = T)
      
    }
    
    ## cross validate to RF model
    if( cv.rf ){
      params <- d
      fit <- train(train.data, train.label, params, run.rf = T)
      #print(dim(fit$importance))
      #print('world')
      pred <- test(fit, test.data, test.rf = T)
      #print('yeah')
    }
    
    ## cross validate LDA model
    if( cv.lda ){
      
      fit <- train(train.data, train.label, params = NULL, run.lda = T)
      
      pred <- test( fit, test.data, test.lda = T )
      
    }
    
    cv.error[i] <- mean(pred != y.train[s == i,2])  
    
  }			
  
  return(c(mean(cv.error),sd(cv.error)))
  
}
