# ------------------------------ Subsetting ---------------------------------- #

# ------ Subsetting Atomic vectors ------
# Let’s explore the different types of subsetting with a simple vector, x.

x <- c(2.1, 4.2, 3.3, 5.4)

# We start with a simple vector x, that has been crafted so that the number
#   after the decimal point gives the original position in the vector.
# There are a few ways you to subset a vector:
#       Positive Integers
#       Negative Integers
#       Logical Vectors
#       Character Vectors

# ------ Subsetting with positive integers ------
# Positive integers return elements at the specified positions:

x[c(3, 1)] # 3.3, 2.1

order(x)
x[order(x)]

# Duplicated indices yield duplicated values
x[c(1, 1)]

# Real numbers are silently truncated to integers
x[c(2.1, 2.9)]

# ------ Subsetting with negative integers ------
# Negative integers omit elements at the specified positions:

x[-c(3, 1)]

# You can’t mix positive and negative integers in a single subset:

x[c(-1, 2)] # Error

# ------ Subsetting with logical vectors ------
# Logical vectors select elements where the corresponding logical value is TRUE.
# This is probably the most useful type of subsetting
#   because you write the expression that creates the logical vector:

x[c(TRUE, TRUE, FALSE, FALSE)]

x[x > 3]

# If the logical vector is shorter than the vector being subsetted,
#   it will be recycled to be the same length.
x[c(TRUE, FALSE)] # equivalent to x[c(TRUE, FALSE, TRUE, FALSE)]

# A missing value in the index always yields a missing value in the output:
x[c(TRUE, TRUE, NA, FALSE)]

x[c(TRUE, NA)] # recycling rules still apply

# ------ Special cases ------
# Nothing returns the original vector.
# This is not useful for vectors
#   but is very useful for matrices, data frames, and arrays.
# It can also be useful in conjunction with assignment.

x[]

# Zero returns a zero-length vector.
# This is not something you usually do on purpose,
#   but it can be helpful for generating test data.

x[0] # return numeric(0)

# ------ Subsetting with character vectors ------
# If the vector is named,
#   you can also use Character vectors to return elements with matching names.

(y <- setNames(x, letters[1:4]))

y[c("d", "c", "a")]

# Like integer indices, you can repeat indices
y[c("a", "a", "a")]

# When subsetting with [] names must be spelled exactly to find a match
z <- c(abc = 1, def = 2)
z[c("a", "d")]

# ------ Useful Application: Lookup Table ------
# Character matching provides a powerful way to make lookup tables.

x <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x] # subset the labeled vector with the vector of abbreviations

# we can clean up the resulting vector by removing names
unname(lookup[x])


# ------ Subsetting Lists ------
# Subsetting a list works in the same way as subsetting an atomic vector.
# Important: Using a single square bracket [ will always return a list.
# Using a double square bracket [[ or dollar-sign $,
#   as described next, let you pull out the components of the list.

# ------ Subsetting Operators ------
# There subsetting operators: [[ ]] and $ are similar to [ ], except it can only
#   return a single object and it allows you to pull pieces out of a list.
# $ is a useful shorthand for [[ ]] combined with character subsetting.
# You need [[ ]] when working with lists.
# This is because when [ ] is applied to a list it always returns a list:
#   it never gives you the contents of the list.
# To get the contents, you need [[ ]]:

# # # # # # # # # # # # # # # # # # # # # # #
# “If list x is a train carrying objects,   #
#   then x[[5]] is the object in car 5;     #
#   x[4:6] is a train of cars 4-6.”         #
#                           - @RLangTip     #
# # # # # # # # # # # # # # # # # # # # # # #

# ------ Double square brackets ------
# Because it can return only a single object,
#   you must use [[ ]] with either a single positive integer or a single string

a <- list(x = 1:4, y = 9:6)
a

a[[1]]
a[["y"]]

# ------ Single vs double square brackets ------

a[c("y", "x", "x")] # can use single brackets with a vector of multiple items

a[[c("y", "x")]] # this does not work

# Sidenote: Recursive Subsetting
# Putting a vector of multiple elements in double square brackets
#   performs recursive subsetting.
# a[[c("y","x")]] is actually equivalent to a[["y"]][["x"]] which only works if
#   a is a list with element y, and y itself has an element inside it called x.

a <- list(x = 1:4, y = list(x = "a", z = "b"))
str(a)

a[["y"]][["x"]]
a[[c("y", "x")]]

d <- list(
  a = c(1, 2, 3),
  b = c(TRUE, TRUE, FALSE),
  c = c("a")
)
str(d)

d[1] # single square bracket returns a list containing the first element
typeof(d[1]) # List

d[[1]] # double square bracket returns the contents of the first element
typeof(d[[1]]) # Double

# let's make a new list
l1 <- list(
  1:8,
  letters[1:4],
  5:1
) # The list has three elements, but they are unnamed
str(l1)

l1[1] # this is a list. returns the first train car
l1[[1]] # this is a vector. the contents of the first train car

l1[1][2] # l1[1] is a list of one item. It has no second element
l1[[1]][2] # l1[[1]] is the integer vector 1:8. The second element is 2.
l1[[c(1, 2)]] # Recursive subsetting: l1[[c(1,2)]] is equal to l1[[1]][[2]]

# A list inside a list (A train inside a train car)

# l2 has 3 elements: the first is the list l1
# the second and third elements are vectors
l2 <- list(l1, c(10, 20, 30), LETTERS[4:9])
str(l2)

# subsetting with a single square bracket returns a list of one element
#   which itself contains the list l1
l2[1]

# str shows that it is a list in a list
str(l2[1])

# double square bracket returns the contents of the first element
# which is the list l1 (just the listt)
l2[[1]]

# str reveals we have just the list, not a list in a list
str(l2[[1]])

# Pay Attention to the differences:
l2[[1]][1]
l2[[1]][1][2]
l2[[1]][[1]]
l2[[1]][[1]][2]

# ------- Double square brackets on atomic vectors ------
# Double square brackets with atomic vectors behave similarly
#   to the use of single square brackets with a few key differences,
#   particularly in handling out-of-bounds indexes.

x <- c("a" = 1, "b" = 2, "c" = 3)
x[1] # single square brackets preserve names
x[[1]] # double square brackets drop names

x <- 1:3
x[5] # single square brackets return NA for out-of-bounds index
x[[5]] # double square brackets return error for out-of-bounds index
x[NULL] # single square brackets return length 0 vectors for 0 or NULL
x[[NULL]] # double square brackets return error for 0 or NULL

# Similar rules for out-of-bounds indexes happen
#   with single vs double square brackets with lists.

# Let’s take a look at l1 again.
l1
l1[4] # out of bounds returns a train car with NULL inside
l1[[4]] # common error in for loops
l1[NULL] # NULL or 0 returns no train cars
l1[[NULL]] # double square brackets return error for 0 or NULL

# ------ Subsetting Matrices and arrays ------
# You can subset higher-dimensional structures in three ways:
#       With multiple vectors. (Most common method)
#       With a single vector.
#       With a matrix. (least common)

# The most common way of subsetting matrices (2d) and arrays (>2d) is
#   a simple generalisation of 1d subsetting:
#       you supply a 1d index for each dimension, separated by a comma.
# Blank subsetting is now useful because
#   it lets you keep all rows or all columns.

a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a

a[1:2, ] # first and second rows
a[c(T, F, T), c("B", "A")] # first and third rows, columns b and a only
a[0, -2] # no rows, all but the second column

# By default, single square bracket subsetting [ will
#   simplify the results to the lowest possible dimensionality.
# We will later discuss preservation to avoid this.

is.vector(a) # matrix is not a vector

a[1, ] # no longer a matrix
is.vector(a[1, ]) # when you subset the row, it becomes a vector

# Because matrices and arrays are implemented as vectors with special attribute,
# you can subset them with a single vector.
# In that case, they will behave like a vector.
# Arrays in R are stored in column-major order:

(vals <- matrix(LETTERS[1:25], nrow = 5))

# select the 8th and 9th values in the vector
vals[c(8, 9)]

# You can also subset higher-dimensional data structures with an integer matrix
#   (or, if named, a character matrix).
# Each row in the matrix specifies the location of one value,
#   where each column corresponds to a dimension in the array being subsetted.
# This means that you use a 2 column matrix to subset a matrix,
#   a 3 column matrix to subset a 3d array, and so on.
# The result is a vector of values:

select <- matrix(
  ncol = 2,
  byrow = TRUE,
  c(
    1, 5, ## select the values at the coordinates (1,5)
    3, 1, ## value at coord (3, 1), third row, 1st col
    2, 3,
    1, 1
  )
)
vals[select]

# generalizes to three dimensions
(ar <- array(1:12, c(2, 3, 2)))

select_ar <- matrix(
  ncol = 3,
  byrow = TRUE,
  c(
    1, 2, 1,
    2, 3, 2
  )
)
ar[select_ar]

# ------ Subsetting Data Frames ------
# Data frames possess the characteristics of both lists and matrices:
#   if you subset with a single vector, they behave like lists;
#   if you subset with two vectors, they behave like matrices.

df <- data.frame(x = 1:4, y = 4:1, z = letters[1:4])
df

df[df$y %% 2 == 0, ] # choose the rows where this logical statement is TRUE

# Select columns like you would a list:
df[c("x", "z")]

# select columns like a matrix
df[, c("x", "z")]

# To select the rows, you can provide a vector before the comma.
# Here we choose the first and third rows.
df[c(1, 3), ] # note the comma

# If you leave out the comma, it will try to subset the data frame like a list.
# In this case, we get the first and third columns and all the rows.
df[c(1, 3)] # comma is missing

# There’s an important difference if you select a single column:
#   matrix subsetting simplifies by default, list subsetting does not.
str(df["x"]) # preserves: remains a data frame
str(df[, "x"]) # simplifies: becomes a vector

str(df$x) # dollar sign always simplifies: becomes a vector
str(df[["x"]]) # simplifies: becomes a vector

# ------ Simplifying vs. preserving ------
# When you subset, R often simplifies the result to an atomic vector
#   or a form different from the original form.
# We saw this with the data frames in previous slides.
# The next few slides cover simplifying vs preserving behaviors
#   in R for different data types

# For atomic vectors simplifying removes names
x <- c(a = 1, b = 2)
x[1] # preserving: keeps names
x[[1]] # simplifying: drops names

# Simplifying return the object inside the list, not a single element list.
y <- list(a = 1, b = 2)
str(y[1]) # preserving: still a list
str(y[[1]]) # simplifying: is a vector

# Factors are a special case.
# For factors, simplifying is achieved by using the argument drop = TRUE
#   inside the square brackets. It drops any unused levels.

z <- factor(c("a", "b"))
z[1] # preserving: keeps levels that do not appear
z[1, drop = TRUE] # simplifying: drops levels that no longer appear

# If subsetting a matrix or array results in a dimension with a length 1,
#   it will drop that dimension.
# For example, when you subset a row from a matrix,
#   R will return an atomic vector rather than a 1 x n matrix.
# If you want to preserve the matrix structure,
#   use the drop = FALSE argument inside the square brackets.

a <- matrix(1:4, nrow = 2)
a[1, , drop = FALSE] # preserving: keeps matrix structure
a[1, ] # simplifying: returns an atomic vector

# Data Frames are lists, so when you subset one like a list,
#   the simplifying vs preserving rules apply.

df <- data.frame(a = 1:2, b = 1:2)
str(df[1]) # preserving: a single square bracket returns a data frame
str(df[[1]]) # simplifying : double brackets returns a vector

# ------ Example of Subsetting ------
head(mtcars, 10)

# What's wrong?
mtcars[mtcars$cyl <= 5] # Error

# need to specify selection of rows with a comma
mtcars[mtcars$cyl <= 5, ]

# What's wrong?
mtcars[mtcars$cyl == 4 | 6, ]

# the mtcars$cyl == 4 | 6
# on the left is a logical vector
# on the right of ’or |’ is the number 6 which gets coerced to TRUE,
# so it returns TRUE for everything

# the or operator has to be between two logical vectors
mtcars[mtcars$cyl == 4 | mtcars$cyl == 6, ]

# What's wrong?
mtcars[1:13]

# without the comma, it tried to select the first 13 names
mtcars[1:13, ]
