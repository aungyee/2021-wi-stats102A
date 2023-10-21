# ------------------------------ data type ---------------------------------- #

# ------ atomic vectors ------
# The most fundamental object in R is an atomic vector (or vector),
#   which is an ordered collection of values.
# Atomic vectors have six basic types

typeof(c(1, 2, 3)) # double
typeof(1:3) # integer
is.double(1) # TRUE
is.integer(1L) # TRUE

# ------ list ------
# A list (or generic vector) is an ordered collection of objects.
# Lists are the most flexible objects in R,
#   as each component in a list can be any other object, including other lists.


# ------ attributes ------
# Every vector (atomic or generic) can also have attributes,
#   which is a named list of arbitrary metadata.
# dimension and class attributes are particularly important
# class attribute develops the S3 object system

head(trees) # dataframe
attributes(trees) # three attributes in a named list

# we can add any arbitrary attributes, this is NOT a normal practice
attr(trees, "info") <- "This data frame is about trees!!" # set attribute
attributes(trees) # new "info" attribute is added

# ------ matrix ------
# A matrix in R is an atomic vector with a dimension attribute of length 2.

m <- 1:10
m # m is an atomic vector of integers
class(m) # integer

attr(m, "dim") <- c(2, 5) # I set dimension attributes
m # M is now a matrix of integers

attributes(m) # only one attribute "dim"
class(m) # class is smart enough to figure out that it’s a matrix

attr(m, "dim") <- NULL # remove the dimension attribute
m # M is back to a vector
class(m)

# ------ array ------
# An array in R is a vector with a dimension attribute of length more than 2.

a <- 1:12
attr(a, "dim") <- c(2, 3, 2)
a

class(a) # array

# Arrays can also be created using array().

# ------ dataframe ------
# A data frame in R is internally stored as a list of equal length vectors
#   with a class attribute called data.frame

head(trees, 4)
class(trees) # data.frame
typeof(trees) # list

# ------ factors ------
# A factor is a vector used to represent categorical values.
# It is internally stored as an integer vector with levels and class attributes.

gender <- c("M", "F", "F", "X", "M", "F")
typeof(gender) # character
class(gender) # character

gender_fac <- factor(gender)
gender_fac
typeof(gender_fac) # integer
class(gender_fac) # factor

levels(gender_fac) # M, F, X

# Internally, the factor is an integer vector.
# When displayed, it replaces the integer with the corresponding level.

gender_fac
as.integer(gender_fac)
attributes(gender_fac) # level and class

# Watch out!
# If a vector of numbers get turned into factors,
#   the unique values get stored as levels.
# This can lead to unexpected results if you aren’t careful.

x <- c(0, 1, 10, 5)
x_fac <- factor(x)
x_fac

mean(x_fac) # we try to take the mean but it doesn’t work

# so we coerce to numeric, but the result doesn’t make sense
mean(as.numeric(x_fac)) # the mean of 0, 1, 10, 5 should be 4

as.numeric(x_fac) # this is because internally, they are stored as integers

x_fac # again, x_fac is a factor

mean(as.numeric(as.character(x_fac))) # this works

# You can’t meaningfully combine factors with c()
c(factor(c("a", "b")), factor(c("b", "c"))) # !!! this works now in 4.3.1

# You can’t use values that are not in the levels
gender_fac[2] <- "male"

gender_fac # Now we have an NA

# ------ coersion ------
# To illustrate the idea of coercion, we create the following vectors.

l <- c(TRUE, FALSE)
i <- 1L
d <- c(5, 6, 7)
ch <- c("a", "b")

# Atomic vectors in R can only contain one data type.
# When values of different types are combined into a single vector,
#   the values are coerced into a single type.

typeof(c(l, i, d))
typeof(c(l, d, ch))

# Coercion looks at the least restrictive type and coerces all to that type.
# The order from most restrictive to least restrictive is
#   logical < integer < double < character < list

c(l, i, d)
typeof(c(l, i, d))

c(l, i, ch)
typeof(c(l, d, ch))

# ------ implicit coersion ------
# Coercion often happens automatically.
# Most mathematical functions (+, log(), abs(), etc.)
#   will coerce to a double or integer,
#   and most logical operations (&, |, any(), etc.) will coerce to a logical.

trials <- c(FALSE, FALSE, TRUE)
as.numeric(trials)

sum(trials) # Total number of TRUEs
mean(trials) # Proportion that are TRUE

# ------ explicit coersion ------
# The as functions can be used to explicitly coerce objects, if possible.

as.character(trials)
as.logical(c(0, 1))
as.numeric("cat") # Not possible

# anything numeric that is not 0 becomes TRUE except NaN becomes NA
as.logical(c(0, 1, -1, 0.1, 2, -Inf, 2.2e-308, NaN))

# accepted spellings of logical values
as.logical(c("F", "FALSE", "False", "false", "T", "TRUE", "True", "true"))

as.logical(c("f", "t", "cat", 0, 1)) # other characters not coerced

# ------ special values ------
# What is the difference between NA, NULL, and NaN?
# NA is used to represent missing or unknown values. There are NA for each type.
# NULL is used to represent a empty or nonexistent value. NULL is its own type.
# NaN is type double and represent indeterminate forms in mathematics:
#   (such as 0/0 or -Inf + Inf).

# Including NA in an atomic vector of matrix will not change the data type.
#   Internally, R has an NA for each data type.
#       NA
#       NA_integer_
#       NA_real_
#       NA_character_

# To check for NA, you must use the function is.na(). You cannot use ==
NA == NA # won't work

is.na(NA)

# R uses NULL to represent the NULL object. It is its own type.
typeof(NULL)
is.null(NULL)
is.na(NULL) # return empty logical vector

is.logical(NULL) # False
NULL + FALSE # operations with NULL result in a length 0 vector
c(4, 5, NULL, 3) # "including" NULL is like including nothing
NULL == NULL # return empty logical vector

# ------ vector arithmetic ------
# Arithmetic can be done on numeric vectors
#   using the usual arithmetic operations.
# The operations are vectorized,
#   i.e., they are applied elementwise (to each individual element).

x <- c(1, 2, 3)
y <- c(100, 200, 300)
x + y
x * y

# ------ vector recycling ------
# When applying arithmetic operations to two vectors of different lengths,
# R will automatically recycle, or repeat,
#   the shorter vector until it is long enough to match the longer vector.

c(1, 2, 3) + c(100, 200, 300, 400, 500, 600)
c(1, 2, 3) + c(100, 200, 300, 400, 500) # warning thrown

# ------ vector recycling (Matrices) ------
m <- rbind(
  c(1, 2, 3),
  c(4, 5, 6),
  c(7, 8, 9),
  c(10, 11, 12)
)
print(m)

x <- c(100, 200, 300)
m + x # recycling is done column-wise

t(m) # t() transposes the matrix
t(m) + x # recycling is still done column-wise
t(t(m) + x) # transposing the result is equivalent to recycling row-wise

# --------------------------------------------------------------------------- #