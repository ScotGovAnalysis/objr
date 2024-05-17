
test_that("Single character value returned", {

  expect_type(random_uuid(), "character")

  expect_length(random_uuid(), 1)

})

test_that("Returned value format correct", {

  pattern_exp <- paste(rep("[a-z0-9]{4}", 8), collapse = "-")

  expect_true(grepl(pattern = pattern_exp, x = random_uuid()))

})

test_that("Not setting seed returns random value", {

  sample_5 <- replicate(5, random_uuid())

  expect_true(length(unique(sample_5)) == 5)

})

test_that("Setting seed returns consistent value", {

  expect_identical(
    random_uuid(1234),
    random_uuid(1234)
  )

})

