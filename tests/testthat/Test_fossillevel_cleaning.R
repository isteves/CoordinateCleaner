context("Fossil cleaning tc_*")

set.seed(1)
#cf_range
minages <- runif(n = 11, min = 0.1, max = 25)
test <- data.frame(species = c(letters[1:10], "z"),
                lng = c(runif(n = 9, min = 4, max = 16), 75, 7),
                lat = c(runif(n = 11, min = -5, max = 5)),
                min_ma = minages, 
                max_ma = minages + c(runif(n = 10, min = 0, max = 5), 25))



# cf_range
test_that("cf_range identifies existing bias", {
  #return value
  expect_is(cf_range(test, value = "flagged", taxon = ""), "logical")
  expect_is(cf_range(test, value = "clean", taxon = ""), "data.frame")
  
  #outlier method
  expect_equal(sum(cf_range(test, value = "flagged", 
                            method = "quantile", taxon = "")), 10)
  expect_equal(sum(cf_range(test, value = "flagged", 
                            method = "mad", taxon = "")), 10)
  expect_equal(sum(cf_range(test, value = "flagged", 
                            method = "time", taxon = "", 
                            max_range = 20)), 10)
  
  expect_equal(sum(cf_range(test, value = "clean", 
                            method = "quantile", taxon = "",
                            uniq_loc = TRUE)), 10)
  
})

#cf_age
test_that("cf_age runs", {
  #return value
  expect_is(cf_age(test, value = "flagged", taxon = ""), "logical")
  expect_is(cf_age(test, value = "clean", taxon = ""), "data.frame")
  
  #outlier method
  expect_equal(sum(cf_age(test, value = "flagged", 
                          method = "quantile", taxon = "")), 11)
  expect_equal(sum(cf_age(test, value = "flagged", 
                          method = "quantile", taxon = "", uniq_loc = F)), 11)
  expect_equal(sum(cf_age(test, value = "flagged", 
                          method = "mad", taxon = "")), 11)
  expect_equal(sum(cf_age(test, value = "flagged", 
                          method = "mad", taxon = "", uniq_loc = F)), 11)
})


#cf_outl
set.seed(1)
minages <- c(runif(n = 11, min = 10, max = 25), 62.5)
test <- data.frame(species = c(letters[1:10], rep("z", 2)),
                lng = c(runif(n = 10, min = 4, max = 16), 75, 7),
                lat = c(runif(n = 12, min = -5, max = 5)),
                min_ma = minages, 
                max_ma = c(minages[1:11] + 
                             runif(n = 11, min = 0, max = 5), 65))

test_that("cf_outl identifies existing bias", {
  #return value
  expect_is(cf_outl(test, value = "flagged", taxon = ""), "logical")
  expect_is(cf_outl(test, value = "clean", taxon = ""), "data.frame")
  
  #outlier method
  expect_equal(sum(cf_outl(test, value = "flagged", 
                           method = "quantile", taxon = "")), 10)
  expect_equal(sum(cf_outl(test, 
                           taxon = "", 
                           value = "flagged", 
                           method = "quantile")), 10)
  expect_equal(sum(cf_outl(test, value = "flagged", 
                           method = "mad", 
                           taxon = "")), 10)
  expect_equal(sum(cf_outl(test, value = "flagged", 
                           method = "mad", 
                           taxon = "")), 10)
  
  
  
  
})






