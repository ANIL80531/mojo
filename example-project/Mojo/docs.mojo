MOJO MANUAL

Combined with the Mojo API reference, this documentation provides
everything you need to write high-performance Mojo code for CPUs and
GPUs.

ABOUT MOJO​

Mojo is a systems programming language specifically designed for
high-performance AI infrastructure and heterogeneous hardware. Its
Pythonic syntax makes it easy for Python programmers to learn and it
fully integrates the existing Python ecosystem, including its wealth
of AI and machine-learning libraries.

It's the first programming language built from the ground-up using
MLIR—a modern compiler infrastructure for heterogeneous hardware,
from CPUs to GPUs and other AI ASICs. That means you can use one
language to write all your code, from high-level AI applications all
the way down to low-level GPU kernels, without using any
hardware-specific libraries (such as CUDA and ROCm).

Learn more about it in the Mojo vision doc.

KEY FEATURES​

 	*
PYTHON SYNTAX & INTEROP: Mojo adopts (and extends) Python's syntax and
integrates with existing Python code. Mojo's interoperability works in
both directions, so you can import Python libraries into Mojo and
create Mojo bindings to call from Python. Read about Python interop.

 	*
STRUCT-BASED TYPES: All data types—including basic types such as
String and Int—are defined as structs. No types are built into the
language itself. That means you can define your own types that have
all the the same capabilities as the standard library types. Read
about structs.

 	*
ZERO-COST TRAITS: Mojo's trait system solves the problem of static
typing by letting you define a shared set of behaviors that types
(structs) can implement. It allows you to write functions that depend
on traits rather than specific types, similar to interfaces in Java or
protocols in Swift, except with compile-time type checking and no
run-time performance cost. Read about traits.

 	*
VALUE SEMANTICS: Mojo supports both value and reference semantics, but
generally defaults to value semantics. With value semantics, each copy
is independent—modifying one copy won't affect another. With
reference semantics, multiple variables can point to the same instance
(sometimes called an object), so changes made through one variable are
visible through all others. Mojo-native types predominantly use value
semantics, which prevents multiple variables from unexpectedly sharing
the same data. Read about value semantics.

 	*
VALUE OWNERSHIP: Mojo's ownership system ensures that only one
variable "owns" a specific value at a given time—such that Mojo can
safely deallocate the value when the owner's lifetime ends—while
still allowing you to share references to the value. This provides
safety from errors such as use-after-free, double-free, and memory
leaks without the overhead cost of a garbage collector. Read about
ownership.

 	*
COMPILE-TIME METAPROGRAMMING: Mojo's parameterization system enables
powerful metaprogramming in which the compiler generates a unique
version of a type or function based on parameter values, similar to
C++ templates, but more intuitive. Read about parameterization.

 	*
HARDWARE PORTABILITY: Mojo is designed from the ground up to support
heterogeneous hardware—the Mojo compiler makes no assumptions about
whether your code is written for CPUs, GPUs, or something else.
Instead, hardware behaviors are handled by Mojo libraries, as
demonstrated by types such as SIMD that allows you to write vectorized
code for CPUs, and the gpu package that enables hardware-agnostic GPU
programming. Read about GPU programming.


GET STARTED WITH MOJO | MODULAR

Get ready to learn Mojo! This tutorial gives you a tour of Mojo by
building a complete program that does much more than simply printing
"Hello, world!"

We'll build a version of Conway's Game of Life, which is a simulation
of self-replicating systems. If you haven't heard of it before, don't
worry—it will make sense when you see it in action. Let's get
started so you can learn Mojo programming basics, including the
following:

 	* Using basic built-in types like Int and String
 	* Using a List to manage a sequence of values
 	* Creating custom types in the form of structs (data structures)
 	* Creating and importing Mojo modules
 	* Importing and using Python libraries

There's a lot to learn, but we've tried to keep the explanations
simple. If you just want to see the finished code, you can get it on
GitHub.

System requirements:

1. CREATE A MOJO PROJECT​

To install Mojo, we recommend using pixi (for other options, see the
install guide).

 	*
If you don't have pixi, you can install it with this command:

curl -fsSL https://pixi.sh/install.sh | sh

 	*
Navigate to the directory where you want to create the project and
execute:

pixi init life \
  -c https://conda.modular.com/max-nightly/ -c conda-forge \
  && cd life

This creates a project directory named life, adds the Modular conda
package channel, and navigates into the directory.

 	*
Install the mojo package:

pixi add mojo

 	*
Now let's list the project contents:

.gitattributes
.gitignore
.pixi
pixi.lock
pixi.toml

You should see that the project directory contains:

 	*
An initial pixi.toml manifest file, which defines the project
dependencies and other features

 	*
A lock file named pixi.lock, which specifies the transitive
dependencies and actual package versions installed in the project's
virtual environment

Never edit the lock file directly. The pixi command automatically
updates the lock file if you edit the manifest file.

 	*
A .pixi subdirectory containing the conda virtual environment for the
project

 	*
Initial .gitignore and .gitattributes files that you can optionally
use if you plan to use Git version control with the project

Let's verify that our project is configured correctly by checking the
version of Mojo that's installed in our project's virtual environment.
pixi run executes a command in the project's virtual environment, so
let's use it to execute mojo --version:

pixi run mojo --version

You should see a version string indicating the version of Mojo
installed, which by default should be the latest version. You can view
and edit the version for your project in the dependencies list in the
pixi.toml file.

Great! Now let's write our first Mojo program.

2. CREATE A "HELLO, WORLD" PROGRAM​

In the project directory, create a file named life.mojo containing the
following lines of code:

life.mojo

# My first Mojo program!
def main():
    print("Hello, World!")

If you've programmed in Python before, this should look familiar.

 	* We're using the def keyword to define a function named main.
 	* You can use any number of spaces or tabs for indentation as long
as you use the same indentation for the entire code block. We'll
follow the Python style guide and use 4 spaces.
 	* This print() function is a Mojo built-in, so it doesn't require an
import.

An executable Mojo program _requires_ you to define a no-argument
main() function as its entry point. Running the program automatically
invokes the main() function, and your program exits when the main()
function returns.

To run the program, we first need to start a shell session in our
project's virtual environment:

pixi shell

Later on, when you want to exit the virtual environment, just type
exit.

Now we can use the mojo command to run our program.

mojo life.mojo

Hello, World!

Mojo is a compiled language, not an interpreted one like Python. When
we run our program like this, mojo performs just-in-time compilation
(JIT) and then runs the result.

We can also compile our program into an executable file using mojo
build like this:

mojo build life.mojo

By default, this saves an executable file named life to the current
directory.

Hello, World!

3. CREATE AND USE VARIABLES​

Let's extend this basic program by prompting the user for their name
and including it in the greeting. The built-in input() function
accepts an optional String argument to use as a prompt and returns a
String consisting of the characters the user entered (with the newline
character at the end stripped off).

Let's declare a variable, assign the return value from input() to it,
and build a customized greeting.

life.mojo

def main():
    var name: String = input("Who are you? ")
    var greeting: String = "Hi, " + name + "!"
    print(greeting)

Go ahead and run it:

mojo life.mojo

Who are you? Edna
Hi, Edna!

Notice that this code uses a String type annotation that indicates the
type of value the variable can contain. The Mojo compiler performs
static type checking, which means you'll encounter a compile-time
error if your code tries to assign a value of one type to a variable
of a different type.

Mojo also supports implicitly declared variables, where you simply
assign a value to a new variable without using the var keyword or
indicating its type. We can replace the code we just entered with the
following, and it works exactly the same.

life.mojo

def main():
    name = input("Who are you? ")
    greeting = "Hi, " + name + "!"
    print(greeting)

However, implicitly declared variables still have a fixed type, which
Mojo automatically infers from the initial value assignment. In this
example, both name and greeting are inferred as String type variables.
If you then try to assign an integer value like 42 to the name
variable, you'll get a compile-time error because of the type
mismatch. You can learn more about Mojo variables in the Variables
section of the Mojo manual.

4. USE MOJO INT AND LIST TYPES TO REPRESENT THE GAME STATE​

As originally envisioned by John Conway, the game's "world" is an
infinite, two-dimensional grid of square cells, but for our
implementation, we'll constrain the grid to a finite size. A drawback
of making the edges of the grid a hard boundary is that there are
fewer neighboring cells around the edges compared to the interior,
which tends to cause die-offs. Therefore, we'll model the world as a
toroid (a donut shape), where the top row is considered adjacent to
the bottom row, and the left column is considered adjacent to the
right column. This will come into play later when we implement the
algorithm for calculating each subsequent generation.

To keep track of the height and width of our grid, we'll use Int,
which represents a signed integer of the word size of the CPU,
typically 32 or 64 bits.

To represent the state of an individual cell, we'll use an Int value
of 1 (populated) or 0 (unpopulated). Later, when we need to determine
the number of populated neighbors surrounding a cell, we can simply
add the values of the neighboring cells.

To represent the state of the entire grid, we need a collection type.
The most appropriate for this use case is List, which is a
dynamically-sized sequence of values.

All values in a Mojo List must be the same type so the Mojo compiler
can ensure type safety. (For example, when we retrieve a value from a
List[Int], the compiler knows the value is an Int and can verify that
we use it correctly.) Mojo collections are implemented as generic
types, so we can indicate the type of values the specific collection
will hold by specifying a type parameter in square brackets like this:

# The List in row can contain only Int values
row = List[Int]()

# The List in names can contain only String values
names = List[String]()

We can also create a List with an initial set of values and let the
compiler infer the type. Use the _list literal_ syntax and simply
enclose the values in square brackets ([]):

# Create a List[Int] with the list literal syntax, inferring the type
nums2 = [12, -7, 64]

# which is equivalent to
nums2: List[Int] = [12, -7, 64]

The Mojo List type includes the ability to append to the list, pop
values from the list, and access list items using subscript notation.
Here's a taste of those operations:

nums = [12, -7, 64]
nums.append(-937)
print("Number of elements in the list:", len(nums))
print("Popping last element off the list:", nums.pop())
print("First element of the list:", nums[0])
print("Second element of the list:", nums[1])
print("Last element of the list:", nums[-1])

Number of elements in the list: 4
Popping last element off the list: -937
First element of the list: 12
Second element of the list: -7
Last element of the list: 64

We can also nest Lists:

grid = [
    [11, 22],
    [33, 44]
]
print("Row 0, Column 0:", grid[0][0])
print("Row 0, Column 1:", grid[0][1])
print("Row 1, Column 0:", grid[1][0])
print("Row 1, Column 1:", grid[1][1])

Row 0, Column 0: 11
Row 0, Column 1: 22
Row 1, Column 0: 33
Row 1, Column 1: 44

This looks like a good way to represent the state of the grid for our
program. Let's update the main() function with the following code that
defines an 8×8 grid containing the initial state of a "glider"
pattern.

life.mojo

def main():
    num_rows = 8
    num_cols = 8
    glider = [
        [0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
    ]

COPYING VALUES IN MOJO​

Before we move on, let's take a moment to discuss how Mojo handles
copying values. There's an important difference in Mojo between
copying simple types like Int and String and more complex types like
List:

 	*
An _explicitly copyable_ type can be copied by calling its copy()
method. List is explicitly copyable, so if first is a List, you can
copy it like this:

first = [1, 2, 3]
second = first.copy()  # explicit copy

This leaves first unchanged and assigns second its own, uniquely owned
copy of the list.

 	*
An _implicitly copyable_ type can be copied without an explicit call
to a copy() method. Int and String are implicitly copyable types, so
if one_value is an Int, you can copy it like this:

one_value = 15
another_value = one_value  # implicit copy

Here, one_value is unchanged, and another_value gets a copy of the
value.

Implicit copying is useful for simple types like Int and String, where
copying is inexpensive and has no side effects. In contrast, a List
might occupy megabytes of memory, and unintentionally copying it could
be a significant performance hit. Therefore, the List type supports
only explicit copying to prevent accidental copying. Understanding
this distinction will be important when we define and use our own
custom types later in this tutorial.

You can determine whether a type is explicitly or implicitly copyable
by checking its API documentation to see what _traits_ it conforms to.
A Mojo trait is a set of requirements that a type must implement,
usually in the form of one or more method signatures.

 	*
The List type and other Mojo collection types like Dict and Set
conform to the Copyable trait, which indicates that they are
EXPLICITLY COPYABLE.

 	*
The String, Int and other numeric types conform to the
ImplicitlyCopyable trait, which indicates that they are IMPLICITLY
COPYABLE. Additionally, the ImplicitlyCopyable trait inherits from the
Copyable and Movable traits, so you can also use types that conform to
the ImplicitlyCopyable trait in the same way you can use types that
conform to the other traits.

5. CREATE AND USE A FUNCTION TO PRINT THE GRID​

Now let's create a function to generate a string representation of the
game grid so we can print it to the terminal.

There are actually two different keywords we can use to define
functions in Mojo: def and fn. Using fn gives us finer-level control
over the function definition, whereas def provides a good set of
default behaviors for most use cases. See Functions for more
information about defining and using functions in Mojo.

Let's add the following definition of a function named grid_str() to
our program. The Mojo compiler doesn't care whether we add our
function before or after main(), but the convention is to put main()
at the end.

life.mojo

fn grid_str(rows: Int, cols: Int, grid: List[List[Int]]) -> String:
    # Create an empty String
    str = String()

    # Iterate through rows 0 through rows-1
    for row in range(rows):
        # Iterate through columns 0 through cols-1
        for col in range(cols):
            if grid[row][col] == 1:
                str += "*"  # If cell is populated, append an asterisk
            else:
                str += " "  # If cell is not populated, append a space
        if row != rows-1:
            str += "\n"     # Add a newline between rows, but not at the end
    return str

When we pass a value to a Mojo function, the default behavior is that
an argument is treated as a _read-only reference_ to the value. This
is particularly useful for values like Lists, where copying them could
be expensive. As we'll see later, we can specify different behavior by
including an explicit argument convention.

Each argument name is followed by a type annotation indicating the
type of value you can pass to the argument. Just like when assigning a
value to a variable, you'll encounter a compile-time error if your
code tries to pass a value of one type to an argument of a different
type. Finally, the -> String following the argument list indicates
that this function has a String type return value.

In the body of the function, we generate a String by appending an
asterisk for each populated cell and a space for each unpopulated
cell, separating each row of the grid with a newline character. We use
nested for loops to iterate through each row and column of the grid,
using range() to generate a sequence of integers from 0 up to (but not
including) the given end value. Then we append the correct characters
to the String representation. See Control flow for more information
about if, for, and other control flow structures in Mojo.

As described in The for statement section of the Mojo manual, it's
possible to iterate over the elements of a List directly instead of
iterating over the values of a range() and then accessing the List
elements by their numeric index.

nums = [12, -7, 64]
for value in nums:
    print("Value:", value)

Now that we've defined our grid_str() function, let's invoke it from
main().

life.mojo

def main():
    ...
    result = grid_str(num_rows, num_cols, glider)
    print(result)

Then run the program to see the result:

mojo life.mojo

We can see that the position of the asterisks matches the location of
the 1s in the glider grid.

6. CREATE A MODULE AND DEFINE A CUSTOM TYPE​

We're currently passing three arguments to grid_str() to describe the
size and state of the grid to print. A better approach would be to
define our own custom type that encapsulates all information about the
grid. Then any function that needs to manipulate a grid can accept a
single argument. We can do this by defining a Mojo _struct_, which is
a custom data structure.

A Mojo struct is a custom type consisting of:

 	* _Fields_, which are variables containing the data associated with
the structure
 	* _Methods_, which are functions that we can optionally define to
manipulate instances of the struct that we create
 	* Optionally, a set of traits that the struct conforms to

Mojo structs are similar to classes. However, Mojo structs do _not_
support inheritance. Mojo doesn't support classes at this time.

We could define the struct in our existing life.mojo source file, but
let's create a separate _module_ for the struct. A module is simply a
Mojo source file containing struct and function definitions that can
be imported into other Mojo source files. To learn more about creating
and importing modules, see the Modules and packages section of the
Mojo manual.

Create a new source file named gridv1.mojo in the project directory
containing the following definition of a struct named Grid with three
fields:

gridv1.mojo

@fieldwise_init
struct Grid(Copyable):
    var rows: Int
    var cols: Int
    var data: List[List[Int]]

Mojo requires you to declare all fields in the struct definition. You
can't add fields dynamically at run-time. You must declare the type
for each field, but you cannot assign a value as part of the field
declaration.

The constructor is responsible for initializing the value of all
fields, as well as allocating additional resources and performing any
other configuration required by a new instance of the struct. You
implement a constructor by defining a method named __init__() in the
struct definition. Here's an example of how we _could_ implement the
constructor for Grid:

    fn __init__(out self, rows: Int, cols: Int, var data: List[List[Int]]):
        self.rows = rows
        self.cols = cols
        self.data = data^

The first argument of a constructor is the newly created instance of
the struct, which by convention is named self. The Mojo compiler
automatically passes the instance to the constructor when you create a
new instance of the struct. Note that in a constructor, you must
include the out argument convention for the self argument. The values
of the remaining arguments are assigned to the corresponding fields of
the new instance. (Don't worry about the var keyword and ^ character
for now. We'll discuss both of them in more detail later.)

To reduce the amount of boilerplate code you need to write, Mojo
provides a decorator called @fieldwise_init that automatically
generates a constructor for you that performs "field-wise"
initialization. The constructor's arguments have the same names and
types as the struct's fields and appear in the same order. This means
that given our original definition of Grid, we can create an instance
of Grid like this:

my_grid = Grid(2, 2, [[0, 1], [1, 1]])

We can then access the field values with "dot" syntax like this:

print("Rows:", my_grid.rows)

However, we also need to be able to copy and move instances of
Grid—for example, when we pass an instance of Grid to a function or
method. Mojo structs support several different lifecycle methods that
define the behavior when an instance of the struct is created, moved,
copied, and destroyed.

Structs that conform to the Movable trait denote a type whose value
can be moved, and structs that conform to the Copyable trait denote a
type whose value can be _explicitly_ copied and/or moved. You can then
implement custom move and copy constructors that perform the necessary
operations to move or copy the instance.

As a convenience for structs that are basic aggregations of other
types and don't require custom resource management or lifecycle
behaviors, you can simply indicate that the struct conforms to the
Movable or Copyable traits without implementing the corresponding
lifecycle methods. In that case, the Mojo compiler automatically
generates the missing methods for you. For our simple Grid struct,
indicating that it conforms to the Copyable trait is enough to have
the Mojo compiler automatically generate the missing methods for us.
The Copyable trait also provides a default implementation of the
copy() method, so you don't need to implement it yourself.

If you define a simple struct where all fields are types that conform
to the ImplicitlyCopyable trait—such as String and numeric
types—you could indicate that your struct conforms to the
ImplicitlyCopyable trait instead of the Copyable trait. However, our
Grid struct uses a List[List[Int]] field, which is not implicitly
copyable.

Also see the Life of a value section of the Mojo Manual for more
information about the different lifecycle methods and how to implement
them.

7. IMPORT A MODULE AND USE OUR CUSTOM GRID TYPE​

Now let's edit life.mojo to import Grid from our new module and update
our code to use it.

life.mojo

from gridv1 import Grid

fn grid_str(grid: Grid) -> String:
    # Create an empty String
    str = String()

    # Iterate through rows 0 through rows-1
    for row in range(grid.rows):
        # Iterate through columns 0 through cols-1
        for col in range(grid.cols):
            if grid.data[row][col] == 1:
                str += "*"  # If cell is populated, append an asterisk
            else:
                str += " "  # If cell is not populated, append a space
        if row != grid.rows - 1:
            str += "\n"     # Add a newline between rows, but not at the end
    return str

def main():
    glider = [
        [0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
    ]
    start = Grid(8, 8, glider^)
    result = grid_str(start)
    print(result)

All these changes are straightforward except for the line where we
create the Grid instance. Our new Grid needs to take _ownership_ of
the List[List[Int]] representing the grid state. (Technically, the
data field of the Grid will own the value.) However, the glider
variable currently owns the list.

One alternative—if we plan to use the value of the glider variable
again later in main()—would be to create a copy of the glider list
to pass to the Grid constructor, like this:

    start = Grid(8, 8, glider.copy())

In our case, we don't need to use the glider variable again later, so
we can instead use the ^ transfer sigil to _transfer ownership_ of the
list to the corresponding argument of the Grid constructor. After the
transfer, the glider variable is uninitialized. You would need to
assign a new value to it if you want to use the variable again. For
more information about ownership and the ^ transfer sigil, see the
Ownership section of the Mojo manual.

At this point, we've made several changes to improve the structure of
our program, but the output should remain the same.

mojo life.mojo

8. IMPLEMENT GRID_STR() AS A METHOD​

Our grid_str() function is really a utility function unique to the
Grid type. Rather than defining it as a standalone function, it makes
more sense to define it as part of the Grid type as a method.

To do so, move the function into gridv1.mojo and edit it to look like
this (or simply copy the code below into gridv1.mojo):

gridv1.mojo

@fieldwise_init
struct Grid(Copyable):
    var rows: Int
    var cols: Int
    var data: List[List[Int]]

    fn grid_str(self) -> String:
        # Create an empty String
        str = String()

        # Iterate through rows 0 through rows-1
        for row in range(self.rows):
            # Iterate through columns 0 through cols-1
            for col in range(self.cols):
                if self.data[row][col] == 1:
                    str += "*"  # If cell is populated, append an asterisk
                else:
                    str += " "  # If cell is not populated, append a space
            if row != self.rows - 1:
                str += "\n"     # Add a newline between rows, but not at the end
        return str

Aside from moving the code from one source file to another, there are
a few other changes we've made:

 	* The function definition is indented to indicate that it's a method
defined by the Grid struct. This also changes how we invoke the
function. Instead of grid_str(my_grid), we now write
my_grid.grid_str().
 	* We've changed the argument name to self. When you invoke an
instance method, Mojo automatically passes the instance as the first
argument, followed by any explicit arguments you provide. Although we
could use any name we like for this argument, the convention is to
call it self.
 	* We've deleted the argument's type annotation. The compiler knows
the first argument of the method is an instance of the struct, so it
doesn't require an explicit type annotation.
 	* We don't need to add an explicit argument convention to the self
argument because we're using it as a read-only reference to the
instance, which is the default behavior for a method argument.

Now that we've refactored the function into an instance method, we
also need to update the code in life.mojo where we invoke it from
main():

life.mojo

from gridv1 import Grid

def main():
    glider = [
        [0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
    ]
    start = Grid(8, 8, glider^)
    print(start.grid_str())

Once again, our refactoring has improved the structure of our code,
but it still produces the same output. You can verify this by running
the program again.

9. IMPLEMENT SUPPORT FOR THE STRINGABLE TRAIT​

You can convert most Mojo types to String using String(my_val) to
produce a String representation of that instance. However, you'll get
an error if you try to do that with our current implementation of
Grid. Let's fix that.

Because the Mojo compiler performs static type checking, a String
constructor can accept a value only if its type implements some
required behavior—in this case, it only accepts types that can
generate a String representation.

To enforce this, the String() constructors require a type to conform
to either the Stringable or StringableRaising trait. (This type of
function is sometimes referred to as a _generic_ function.) Each trait
requires a conforming type to implement a __str__() method that
returns a String representation. The only difference between the two
traits is that Stringable requires that the method _cannot_ raise an
error, whereas StringableRaising indicates that the method _might_
raise an error. (To learn more, read The Stringable, Representable,
and Writable traits.)

Our grid_str() method already returns a String representation, so it
looks like we just have to rename it to __str__(). However, we also
need to indicate which trait Grid conforms to. In our case, it must be
Stringable instead of StringableRaising because we used fn to define
the method. If you define a function or method with def, the compiler
_always_ assumes the function _can_ raise an error. In contrast, an fn
function is a non-raising function by default (though you can still
declare that it might raise an error using the raises keyword).

In gridv1.mojo, we need to update the Grid declaration to indicate
that the type conforms to Stringable and rename the grid_str() method
to __str__():

gridv1.mojo

@fieldwise_init
struct Grid(Copyable, Stringable):
    ...
    fn __str__(self) -> String:
        ...

Now let's verify that String() works with an instance of Grid.

life.mojo

def main():
    ...
    start = Grid(8, 8, glider^)
    print(String(start))

If you run the program again, you should still see the same glider
pattern as before.

mojo life.mojo

10. IMPLEMENT METHODS TO SUPPORT INDEXING​

Looking at the implementation of __str__(), you'll notice that we use
self.data[row][col] to retrieve the value of a cell in the grid. If
my_grid is an instance of Grid, we would use my_grid.data[row][col] to
refer to a cell in the grid. This breaks a fundamental principle of
encapsulation because we need to know that Grid stores the game state
in a field called data, and that field is a List[List[Int]]. If we
later decide to change the internal implementation of Grid, there
could be a lot of code that would need to be changed.

A cleaner approach is to provide "getter" and "setter" methods to
access cell values. We could simply define methods like get_cell() and
set_cell(), but this is a good opportunity to show how we can define
the behavior of built-in operators for custom Mojo types.
Specifically, we'll implement support for indexing so we can refer to
a cell with syntax like my_grid[row, col]. This will be useful when we
implement support for evolving the state of the grid.

As described in Operators, expressions, and dunder methods, Mojo
allows us to define the behavior of many built-in operators for a
custom type by implementing special _dunder_ (double underscore)
methods. In the case of indexing, the two methods are __getitem__()
and __setitem__(). Let's add the following methods to the Grid struct
in gridv1.mojo:

gridv1.mojo

@fieldwise_init
struct Grid(Copyable, Stringable):
    ...
    fn __getitem__(self, row: Int, col: Int) -> Int:
        return self.data[row][col]

    fn __setitem__(mut self, row: Int, col: Int, value: Int) -> None:
        self.data[row][col] = value

The implementation of __getitem__() is straightforward. For the given
values of row and col, we just need to retrieve and return the
corresponding value from the nested List[List[Int]] stored in the data
field of the instance.

The body of __setitem__() is similarly straightforward. We just take
the given value and store it in the corresponding row and col in data.
One new thing in the declaration is that we set the return type to
None to indicate that the method doesn't have a return value. More
notable is that we've added the mut argument convention to the self
argument to explicitly tell the Mojo compiler that we want to mutate
the state of the current instance. If we were to omit mut, we would
get an error because the compiler would default to read-only access
for the argument.

Now that we've implemented these methods, we can update __str__() to
use indexing syntax to access the cell value.

gridv1.mojo

@fieldwise_init
struct Grid(Copyable, Stringable):
    ...
    fn __str__(self) -> String:
        ...
            # Iterate through columns 0 through cols-1
            for col in range(self.cols):
                if self[row, col] == 1:
                    ...

Click here to see the complete gridv1.mojo so far:

Our refactoring hasn't changed our program's behavior, but it's still
a good idea to run it to ensure we don't have any errors in our code.

11. DEFINE A STATIC METHOD TO GENERATE RANDOM GRIDS​

So far, we've used the glider to build the basic functionality of our
Grid type. However, what's much more interesting is to start with a
grid in a random state and see how it evolves over time.

Let's add a _static method_ named random() to the Grid struct to
generate and return an instance of Grid with a random state. A static
method doesn't operate on specific instances of the type, so it can be
invoked as a utility function. We indicate that a method is static by
using the @staticmethod decorator.

gridv1.mojo

import random

@fieldwise_init
struct Grid(Copyable, Stringable):
    ...
    @staticmethod
    fn random(rows: Int, cols: Int) -> Self:
        # Seed the random number generator using the current time.
        random.seed()

        var data: List[List[Int]] = []

        for _ in range(rows):
            var row_data: List[Int] = []
            for _ in range(cols):
                # Generate a random 0 or 1 and append it to the row.
                row_data.append(Int(random.random_si64(0, 1)))
            data.append(row_data^)

        return Self(rows, cols, data^)

At the top of the file, we're importing the random package from the
Mojo standard library. It includes several functions related to random
number generation.

By default, the pseudorandom number generator used by the Mojo
standard library currently uses a fixed seed. This means it generates
the same sequence of numbers unless you provide a different seed,
which is useful for testing purposes. However, for this application,
we want to call random.seed() to set a seed value based on the current
time, which gives us a unique value every time.

Then we create data as an empty List[List[Int]], which we'll populate
with a random initial state. For each cell, we call
random.random_si64(), which returns a random integer value from the
provided minimum and maximum values of 0 and 1, respectively. This
function actually returns a value of type Int64, which is a signed
64-bit integer value. As described in Numeric types, this is _not_ the
same as the Int type, whose precision is dependent on the native word
size of the system. Therefore, we're passing this value to the Int()
constructor, which explicitly converts a numeric value to an Int.

After creating a complete row of random values, we append it to data.
The List in data _owns_ all its elements, so when we call append(), we
need to decide whether to transfer ownership of the new row or provide
a copy of it. In this case, we don't need to use the row again, so we
use the ^ transfer sigil to transfer ownership of the row to the List
in data. (We didn't need to use the ^ sigil when appending the Int
values because they're _implicitly_ copyable.)

The return type of the method is Self, which is an alias for the type
of the struct. This is a convenient shortcut if the actual name of the
struct is long or includes parameters. The last line uses Self() to
invoke the struct's constructor and return a newly created instance
with random data. Once again, we use the ^ transfer sigil to transfer
ownership of the newly created List[List[Int]] to the new instance
rather than make a copy of it.

The for loops in the code above assign the loop value to "_", the
_discard pattern_, to indicate that it's intentionally not used.
Without this, the Mojo compiler would report a warning that the loop
variable is unused.

Now we can update the main() function in life.mojo to create a random
Grid and print it.

life.mojo

...

def main():
    start = Grid.random(8, 16)
    print(String(start))

Run the program a few times to verify that it generates a different
grid each time.

mojo life.mojo

*** *      ****
*  ****   ******
* * *****
*  * ** **
 *    * ** ****
* **  * * * ***
 * * **  **  **
  * ***** **

12. IMPLEMENT A METHOD TO EVOLVE THE GRID​

It's finally time to let our world evolve. We'll implement an evolve()
method to calculate the state of the grid for the next generation. One
option would be to do an in-place modification of the existing Grid
instance. Instead, we'll have evolve() return a new instance of Grid
for the next generation.

gridv1.mojo

...
struct Grid(Copyable, Stringable):
    ...
    fn evolve(self) -> Self:
        next_generation = List[List[Int]]()

        for row in range(self.rows):
            row_data = List[Int]()

            # Calculate neighboring row indices, handling "wrap-around"
            row_above = (row - 1) % self.rows
            row_below = (row + 1) % self.rows

            for col in range(self.cols):
                # Calculate neighboring column indices, handling "wrap-around"
                col_left = (col - 1) % self.cols
                col_right = (col + 1) % self.cols

                # Determine number of populated cells around the current cell
                num_neighbors = (
                    self[row_above, col_left]
                    + self[row_above, col]
                    + self[row_above, col_right]
                    + self[row, col_left]
                    + self[row, col_right]
                    + self[row_below, col_left]
                    + self[row_below, col]
                    + self[row_below, col_right]
                )

                # Determine the state of the current cell for the next generation
                new_state = 0
                if self[row, col] == 1 and (
                    num_neighbors == 2 or num_neighbors == 3
                ):
                    new_state = 1
                elif self[row, col] == 0 and num_neighbors == 3:
                    new_state = 1
                row_data.append(new_state)

            next_generation.append(row_data^)

        return Self(self.rows, self.cols, next_generation^)

We start with an empty List[List[Int]] to represent the state of the
next generation. Then we use nested for loops to iterate over each row
and column of the existing Grid to determine the state of each cell in
the next generation.

For each cell in the grid, we need to count the number of populated
neighboring cells. Because we're modeling the world as a toroid, we
need to consider the top and bottom rows as adjacent and the leftmost
and rightmost columns as adjacent. As we iterate through each row and
column, we're using the modulo operator (%) to handle "wrap-around"
when we calculate the indices of the rows above and below and the
columns to the left and right of the current cell. (For example, if
there are 8 rows, then -1 % 8 is 7.)

Then we apply the Game of Life rules that determine whether the
current cell is populated (1) or unpopulated (0) for the next
generation:

 	* A populated cell with either 2 or 3 populated neighbors remains
populated in the next generation
 	* An unpopulated cell with exactly 3 populated neighbors becomes
populated in the next generation
 	* All other cells become unpopulated in the next generation

After calculating the state of the next generation, we use Self() to
create a new instance of Grid, and return the newly created instance.

Now that we can evolve the grid, let's use it in life.mojo. We'll add
a run_display() function to control the game's main loop:

 	* Display the current Grid
 	* Prompt the user to continue or quit
 	* Break out of the loop if the user enters q
 	* Otherwise, calculate the next generation and loop again

Note that run_display() declares the grid argument with the var
argument convention to take ownership of the Grid instance. If we used
the default read argument convention instead, grid would be an
immutable reference binding to the original Grid instance. In that
case, we'd get a compile-time error when we tried to assign the result
of grid.evolve() to grid because Mojo doesn't allow you to re-bind a
reference to a different value. See Reference bindings for more
information.

Then we'll update main() to create a random initial Grid and pass it
to run_display(), transferring ownership with the ^ sigil. Here's the
updated version of life.mojo:

life.mojo

from gridv1 import Grid

def run_display(var grid: Grid) -> None:
    while True:
        print(String(grid))
        print()
        if input("Enter 'q' to quit or press <Enter> to continue: ") == "q":
            break
        grid = grid.evolve()

def main():
    start = Grid.random(16, 16)
    run_display(start^)

Run the program and verify that each call to evolve() successfully
produces a new generation.

Now we have a working version of the Game of Life, but the terminal
interface isn't very appealing. Let's spice things up with a nicer
graphical user interface using a Python library.

13. IMPORT AND USE A PYTHON PACKAGE​

Mojo lets you import Python modules, call Python functions, and
interact with Python objects from Mojo code. To demonstrate this
capability, we'll use a Python package called pygame to create and
manage a graphical user interface for our Game of Life program.

First, we need to update our pixi.toml file to add a dependency on
Python and the pygame package. In the project directory, execute the
following command from the terminal:

pixi add "python>=3.11,<3.13" "pygame>=2.6.1,<3"

When you use Python code and packages as part of your Mojo program,
you create a run-time dependency on a compatible Python runtime and
packages. Building an executable version of your program with mojo
build does _not_ incorporate a Python runtime or Python packages into
the resulting executable file. These run-time Python dependencies must
be provided by the environment where you run the executable. The
easiest way to ensure this requirement is met is to deploy and run
your Mojo executable in a virtual environment, such as one managed by
Pixi or conda.

You can import a Python module in Mojo using Python.import_module().
This returns a reference to the module in the form of a PythonObject
wrapper. You must store the reference in a variable so that you can
then access the functions and objects in the module. For example:

from python import Python

def run_display():
    # This is roughly equivalent to Python's `import pygame`
    pygame = Python.import_module("pygame")

    # Initialize pygame modules
    pygame.init()

Because Mojo doesn't support globally scoped variables, you must
either import a Python module into each Mojo function that needs to
use it or pass the PythonObject-wrapped module as an argument between
functions.

You can learn more about importing and using Python modules in Mojo by
reading Python integration.

Once we import pygame, we can call its APIs as if we were writing
Python code. For this project, we'll use pygame to create a new window
and draw the entire game UI. This requires a complete rewrite of the
run_display() function. Take a look at the updated code for life.mojo,
and we'll explain more below:

life.mojo

import time

from gridv1 import Grid
from python import Python

def run_display(
    var grid: Grid,
    window_height: Int = 600,
    window_width: Int = 600,
    background_color: String = "black",
    cell_color: String = "green",
    pause: Float64 = 0.1,
) -> None:
    # Import the pygame Python package
    pygame = Python.import_module("pygame")

    # Initialize pygame modules
    pygame.init()

    # Create a window and set its title
    window = pygame.display.set_mode(Python.tuple(window_width, window_height))
    pygame.display.set_caption("Conway's Game of Life")

    cell_height = window_height / grid.rows
    cell_width = window_width / grid.cols
    border_size = 1
    cell_fill_color = pygame.Color(cell_color)
    background_fill_color = pygame.Color(background_color)

    running = True
    while running:
        # Poll for events
        event = pygame.event.poll()
        if event.type == pygame.QUIT:
            # Quit if the window is closed
            running = False
        elif event.type == pygame.KEYDOWN:
            # Also quit if the user presses <Escape> or 'q'
            if event.key == pygame.K_ESCAPE or event.key == pygame.K_q:
                running = False

        # Clear the window by painting with the background color
        window.fill(background_fill_color)

        # Draw each live cell in the grid
        for row in range(grid.rows):
            for col in range(grid.cols):
                if grid[row, col]:
                    x = col * cell_width + border_size
                    y = row * cell_height + border_size
                    width = cell_width - border_size
                    height = cell_height - border_size
                    pygame.draw.rect(
                        window,
                        cell_fill_color,
                        Python.tuple(x, y, width, height),
                    )

        # Update the display
        pygame.display.flip()

        # Pause to let the user appreciate the scene
        time.sleep(pause)

        # Next generation
        grid = grid.evolve()

    # Shut down pygame cleanly
    pygame.quit()

def main():
    start = Grid.random(128, 128)
    run_display(start^)

Each argument for run_display() other than grid has a default value
associated with it (for example, the default window_height is 600
pixels). If you don't explicitly pass a value for an argument when you
invoke run_display(), Mojo uses the default value specified in the
function definition.

After importing the pygame module, we call pygame.init() to initialize
all pygame subsystems.

The set_mode() function creates and initializes a window with the
width and height passed as a Python tuple of two values. This returns
a PythonObject wrapper for the window, which we can then use to call
functions and set attributes to manipulate the window. (For more
information about interacting with Python objects from Mojo, see
Python types.)

The bulk of the run_display() function is a loop that uses pygame to
poll for events like key presses and mouse clicks. If it detects that
the user presses q or the <Escape> key or closes the display window,
it ends the program with pygame.quit(). Otherwise, it clears the
window and iterates through all cells in the grid to display the
populated cells. After sleeping for pause seconds, it evolves the grid
to the next generation and loops again.

Now it's time to try it out.

mojo life.mojo

When you run the program, you should see a new window appear on screen
displaying your evolving grid. We now have a fully functional
implementation of the Game of Life with a nice interface. We've come
quite a way from just displaying a few asterisks in the terminal!

To quit the program, press the q or <Escape> key, or close the window.

Now that we're done with the tutorial, exit our project's virtual
environment:

SUMMARY​

Congratulations on writing a complete Mojo application from scratch!
Along the way, you experienced:

 	* Using Pixi to create, build, and run a Mojo program
 	* Using Mojo built-in types like Int, String, and List
 	* Manipulating explicitly and implicitly copyable types
 	* Managing value ownership and references
 	* Creating and using variables and functions
 	* Using control structures like if, while, and for
 	* Defining and using a custom Mojo struct
 	* Creating and importing a Mojo module
 	* Using modules from the Mojo standard library
 	* Importing and using a Python module

GET STARTED WITH GPU PROGRAMMING | MODULAR

This tutorial introduces you to GPU programming with Mojo. You'll
learn how to write a simple program that performs vector addition on a
GPU, exploring fundamental concepts of GPU programming along the way.

By the end of this tutorial, you will:

 	* Understand basic GPU programming concepts like grids and thread
blocks.
 	* Learn how to move data between CPU and GPU memory.
 	* Write and compile a simple GPU kernel function.
 	* Execute parallel computations on the GPU.
 	* Understand the asynchronous nature of GPU programming.

We'll build everything step-by-step, starting with the basics and
gradually adding more complexity. The concepts you learn here will
serve as a foundation for more advanced GPU programming with Mojo. If
you just want to see the finished code, you can get it on GitHub.

System requirements:

1. CREATE A MOJO PROJECT​

To install Mojo, we recommend using pixi (for other options, see the
install guide).

 	*
If you don't have pixi, you can install it with this command:

curl -fsSL https://pixi.sh/install.sh | sh

 	*
Navigate to the directory in which you want to create the project and
execute:

pixi init gpu-intro \
  -c https://conda.modular.com/max-nightly/ -c conda-forge \
  && cd gpu-intro

This creates a project directory named gpu-intro, adds the Modular
conda package channel, and enters the directory.

 	*
Install the mojo package:

pixi add mojo

 	*
Verify the project is configured correctly by checking the version of
Mojo that's installed within our project's virtual environment:

pixi run mojo --version

You should see a version string indicating the version of Mojo
installed. By default, this should be the latest nightly version.

 	*
Activate the project's virtual environment:

pixi shell

Later on, when you want to exit the virtual environment, just type
exit.

2. GET A REFERENCE TO THE GPU DEVICE​

The DeviceContext type represents a logical instance of a GPU device.
It provides methods for allocating memory on the device, copying data
between the host CPU and the GPU, and compiling and running functions
(also known as _kernels_) on the device.

Use the DeviceContext() constructor to get a reference to the GPU
device. The constructor raises an error if no compatible GPU is
available. You can use the has_accelerator() function to check if a
compatible GPU is available.

Let's start by writing a program that checks if a GPU is available and
then obtains a reference to the GPU device. Using any editor, create a
file named vector_addition.mojo with the following code:

vector_addition.mojo

from gpu.host import DeviceContext
from sys import has_accelerator

def main():
    @parameter
    if not has_accelerator():
        print("No compatible GPU found")
    else:
        ctx = DeviceContext()
        print("Found GPU:", ctx.name())

Save the file and run it using the mojo CLI:

mojo vector_addition.mojo

You should see output like the following (depending on the type of GPU
you have):

Found GPU: NVIDIA A10G

Mojo requires a compatible GPU development environment to compile
kernel functions, otherwise it raises a compile-time error. In our
code, we're using the @parameter decorator to evaluate the
has_accelerator() function at compile time and compile only the
corresponding branch of the if statement. As a result, if you don't
have a compatible GPU development environment, you'll see the
following message when you run the program:

No compatible GPU found

In that case, you need to find a system that has a supported GPU to
continue with this tutorial.

3. DEFINE A SIMPLE KERNEL​

A GPU _kernel_ is simply a function that runs on a GPU, executing a
specific computation on a large dataset in parallel across thousands
or millions of _threads_. You might already be familiar with threads
when programming for a CPU, but GPU threads are different. On a CPU,
threads are managed by the operating system and can perform completely
independent tasks, such as managing a user interface, fetching data
from a database, and so on. But on a GPU, threads are managed by the
GPU itself. All the threads on a GPU execute the same kernel function,
but they each work on a different part of the data.

When you run a kernel, you need to specify the number of threads you
want to use. The number of threads you specify depends on the size of
the data you want to process and the amount of parallelism you want to
achieve. A common strategy is to use one thread per element of data in
the result. So if you're performing an element-wise addition of two
1,024-element vectors, you'd use 1,024 threads.

A _grid_ is the top-level organizational structure for the threads
executing a kernel function. A grid consists of multiple _thread
blocks_, which are further divided into individual threads that
execute the kernel function concurrently. The GPU assigns a unique
block index to each thread block, and a unique thread index to each
thread within a block. Threads within the same thread block can share
data through shared memory and synchronize using built-in mechanisms,
but they cannot directly communicate with threads in other blocks. For
this tutorial, we won't get into the details of why or how to do this,
but it's an important concept to keep in mind when you're writing more
complex kernels.

To better understand how grids, thread blocks, and threads are
organized, let's write a simple kernel function that prints the thread
block and thread indices. Add the following code to your
vector_addition.mojo file:

vector_addition.mojo

from gpu import block_idx, thread_idx

fn print_threads():
    """Print thread IDs."""

    print("Block index: [",
        block_idx.x,
        "]\tThread index: [",
        thread_idx.x,
        "]"
    )

We're using fn here without the raises keyword because a kernel
function is not allowed to raise an error condition. In contrast, when
you define a Mojo function with def, the compiler always assumes that
the function _can_ raise an error condition. See the Functions section
of the Mojo Manual for more information on the difference between
using fn and def to define functions in Mojo.

4. COMPILE AND RUN THE KERNEL​

Next, we need to update the main() function to compile the kernel
function for our GPU and then run it, specifying the number of thread
blocks in the grid and the number of threads per thread block. For
this initial example, let's define a grid consisting of 2 thread
blocks, each with 64 threads.

Modify the main() function and add has_apple_gpu_accelerator() to the
list of imports from the sys module so that your program looks like
this:

vector_addition.mojo

from sys import has_accelerator, has_apple_gpu_accelerator

from gpu.host import DeviceContext
from gpu import block_idx, thread_idx

fn print_threads():
    """Print thread IDs."""

    print("Block index: [",
        block_idx.x,
        "]\tThread index: [",
        thread_idx.x,
        "]"
    )

def main():
    @parameter
    if not has_accelerator():
        print("No compatible GPU found")
    elif has_apple_gpu_accelerator():
        print(
            "Printing from a kernel is not currently supported on Apple silicon"
            " GPUs"
        )
    else:
        ctx = DeviceContext()
        ctx.enqueue_function_checked[print_threads, print_threads](
            grid_dim=2, block_dim=64
        )
        ctx.synchronize()
        print("Program finished")

Save the file and run it:

mojo vector_addition.mojo

You should see something like the following output (which is
abbreviated here):

Block index: [ 1 ]    Thread index: [ 32 ]
Block index: [ 1 ]    Thread index: [ 33 ]
Block index: [ 1 ]    Thread index: [ 34 ]
...
Block index: [ 0 ]    Thread index: [ 30 ]
Block index: [ 0 ]    Thread index: [ 31 ]
Program finished

If you're completing this tutorial on macOS

Printing from within a kernel function is not currently supported on
Apple silicon GPUs. If you run this program on macOS, you'll see only
the following output:

Printing from a kernel is not currently supported on Apple silicon GPUs

If you're completing this tutorial on macOS, go ahead and read the
rest of this step and the next step to learn the concepts of compiling
and running a kernel. You'll be able to continue the hands-on portion
of the tutorial starting with 6. Allocate host memory for the input
vectors, where we'll begin writing a different kernel that doesn't use
print().

Typical CPU-GPU interaction is asynchronous, allowing the GPU to
process tasks while the CPU is busy with other work. Each
DeviceContext has an associated stream of queued operations to execute
on the GPU. Operations within a stream execute in the order they are
issued.

The enqueue_function_checked() method compiles a kernel function and
enqueues it to run on the given device. You must provide the name of
the kernel function as a compile-time Mojo parameter, and the
following arguments:

 	* Any additional arguments specified by the kernel function
definition (none, in this case).
 	* The grid dimensions using the grid_dim keyword argument.
 	* The thread block dimensions using the block_dim keyword argument.

(See the Functions section of the Mojo Manual for more information on
Mojo function arguments and the Parameters section for more
information on Mojo compile-time parameters and metaprogramming.)

DeviceContext also includes enqueue_function() and compile_function()
methods. However, these methods currently don't typecheck the
arguments to the compiled kernel function, which can lead to obscure
run-time errors if the argument ordering, types, or count doesn't
match the kernel function's definition. Additionally, these methods
currently have known issues with Apple silicon GPUs.

For compile-time typechecking, we recommend that you use the
enqueue_function_checked() and compile_function_checked() methods,
which also work correctly on Apple silicon GPUs.

Note that enqueue_function_checked() and compile_function_checked()
currently require the kernel function to be provided _twice_ as
parameters. This requirement will be removed in a future API update,
when typechecking will become the default behavior for both
enqueue_function() and compile_function().

In this example, we're invoking the compiled kernel function with
grid_dim=2 and block_dim=64, which means we're using a grid of 2
thread blocks with 64 threads each, for a total of 128 threads in the
grid.

When you run a kernel, the GPU assigns each thread block within the
grid to a _streaming multiprocessor_ for execution. A streaming
multiprocessor (SM) is the fundamental processing unit of a GPU,
designed to execute multiple parallel workloads efficiently. Each SM
contains several cores, which perform the actual computations of the
threads executing on the SM, along with shared resources like
registers, shared memory, and control mechanisms to coordinate the
execution of threads. The number of SMs and the number of cores on a
GPU depends on its architecture. For example, the NVIDIA H100 PCIe
contains 114 SMs, with 128 32-bit floating point cores per SM.

Additionally, when an SM is assigned a thread block, it divides the
block into multiple _warps_, which are groups of 32 or 64 threads,
depending on the GPU architecture. These threads execute the same
instruction simultaneously in a _single instruction, multiple threads_
(SIMT) model. The SM's _warp scheduler_ coordinates the execution of
warps on the SM's cores.

Warps are used to efficiently utilize GPU hardware by maximizing
throughput and minimizing control overhead. Since GPUs are designed
for high-performance parallel processing, grouping threads into warps
allows for streamlined instruction scheduling and execution, reducing
the complexity of managing individual threads. Multiple warps from
multiple thread blocks can be active within an SM at any given time,
enabling the GPU to keep execution units busy. For example, if the
threads of a particular warp are blocked waiting for data from memory,
the warp scheduler can immediately switch execution to another warp
that's ready to run.

After enqueuing the kernel function, we want to ensure that the CPU
waits for it to finish execution before exiting the program. We do
this by calling the synchronize() method of the DeviceContext object,
which blocks until the device completes all operations in its queue.

5. MANAGE GRID DIMENSIONS​

The grid in the previous step consisted of a one-dimensional grid of 2
thread blocks with 64 threads in each block. However, you can also
organize the thread blocks in a two- or three-dimensional grid.
Similarly, you can arrange the threads in a thread block across one,
two, or three dimensions. Typically, you determine the dimensions of
the grid and thread blocks based on the dimensionality of the data to
process. For example, you might choose a 1-dimensional grid for
processing large vectors, a 2-dimensional grid for processing
matrices, and a 3-dimensional grid for processing the frames of a
video.

To better understand how grids, thread blocks, and threads work
together, let's modify our print_threads() kernel function to print
the x, y, and z components of the thread block and thread indices for
each thread.

vector_addition.mojo

fn print_threads():
    """Print thread IDs."""

    print("Block index: [",
        block_idx.x, block_idx.y, block_idx.z,
        "]\tThread index: [",
        thread_idx.x, thread_idx.y, thread_idx.z,
        "]"
    )

Then, update main() to enqueue the kernel function with a 2x2x1 grid
of thread blocks and a 16x4x2 arrangement of threads within each
thread block:

vector_addition.mojo

        ctx.enqueue_function_checked[print_threads, print_threads](
            grid_dim=(2, 2, 1),
            block_dim=(16, 4, 2)
        )

Save the file and run it again:

mojo vector_addition.mojo

You should see something like the following output (which is
abbreviated here):

Block index: [ 1 1 0 ]    Thread index: [ 0 2 0 ]
Block index: [ 1 1 0 ]    Thread index: [ 1 2 0 ]
Block index: [ 1 1 0 ]    Thread index: [ 2 2 0 ]
...
Block index: [ 0 0 0 ]    Thread index: [ 14 1 0 ]
Block index: [ 0 0 0 ]    Thread index: [ 15 1 0 ]
Program finished

Try changing the grid and thread block dimensions to see how the
output changes.

The maximum number of threads per thread block and threads per SM is
GPU-specific. For example, the NVIDIA A100 GPU has a maximum of 1,024
threads per thread block and 2,048 threads per SM.

Choosing the size and shape of the grid and thread blocks is a
balancing act between maximizing the number of threads that can
execute concurrently and minimizing the amount of time spent waiting
for data to be loaded from memory. Factors such as the size of the
data to process, the number of SMs on the GPU, and the memory
bandwidth of the GPU can all play a role in determining the optimal
grid and thread block dimensions. One general guideline is to choose a
thread block size that is a multiple of the warp size. This helps to
maximize the utilization of the GPU's resources and minimizes the
overhead of managing multiple warps.

Now that you understand how to manage grid dimensions, let's get ready
to create a kernel that performs a simple element-wise addition of two
vectors of floating point numbers.

6. ALLOCATE HOST MEMORY FOR THE INPUT VECTORS​

Before creating the two input vectors for our kernel function, we need
to understand the distinction between _host memory_ and _device
memory_. Host memory is dynamic random-access memory (DRAM) accessible
by the CPU, whereas device memory is DRAM accessible by the GPU. If
you have data in host memory, you must explicitly copy it to device
memory before you can use it in a kernel function. Similarly, if your
kernel function produces data that you want the CPU to use later, you
must explicitly copy it back to host memory.

For this tutorial, we'll use the HostBuffer type to represent our
vectors on the host. A HostBuffer is a block of host memory associated
with a particular DeviceContext. It supports methods for transferring
data between host and device memory, as well as a basic set of methods
for accessing data elements by index and for printing the buffer.

Let's update main() to create two HostBuffers for our input vectors
and initialize them with values. You won't need the print_threads()
kernel function anymore, so you can remove it and the code to compile
and invoke it.

After making these changes, your vector_addition.mojo file should look
like this:

vector_addition.mojo

from gpu.host import DeviceContext
from gpu import block_idx, thread_idx
from sys import has_accelerator

# Vector data type and size
comptime float_dtype = DType.float32
comptime vector_size = 1000

def main():
    @parameter
    if not has_accelerator():
        print("No compatible GPU found")
    else:
        # Get the context for the attached GPU
        ctx = DeviceContext()

        # Create HostBuffers for input vectors
        lhs_host_buffer = ctx.enqueue_create_host_buffer[float_dtype](
            vector_size
        )
        rhs_host_buffer = ctx.enqueue_create_host_buffer[float_dtype](
            vector_size
        )
        ctx.synchronize()

        # Initialize the input vectors
        for i in range(vector_size):
            lhs_host_buffer[i] = Float32(i)
            rhs_host_buffer[i] = Float32(i * 0.5)

        print("LHS buffer: ", lhs_host_buffer)
        print("RHS buffer: ", rhs_host_buffer)

The enqueue_create_host_buffer() method accepts the data type as a
compile-time parameter and the size of the buffer as a run-time
argument and returns a HostBuffer. As with all DeviceContext methods
whose name starts with enqueue_, the method is asynchronous and
returns immediately, adding the operation to the queue to be executed
by the DeviceContext. Therefore, we need to call the synchronize()
method to ensure that the operation has completed before we use the
HostBuffer object. Then we can initialize the input vectors with
values and print them.

Now let's run the program to verify that everything is working so far.

mojo vector_addition.mojo

You should see the following output:

LHS buffer:  HostBuffer([0.0, 1.0, 2.0, ..., 997.0, 998.0, 999.0])
RHS buffer:  HostBuffer([0.0, 0.5, 1.0, ..., 498.5, 499.0, 499.5])

You might notice that we don't explicitly call any methods to free the
host memory allocated by our HostBuffers. That's because a HostBuffer
is subject to Mojo's standard ownership and lifecycle mechanisms. The
Mojo compiler analyzes our program to determine the last point that
the owner of or a reference to an object is used and automatically
adds a call to the object's destructor. In our program, we last
reference the buffers at the end of our program's main() method.
However, in a more complex program, the HostBuffer could persist
across calls to multiple kernel functions if it is referenced at later
points in the program. See the Ownership and Intro to value lifecycle
sections of the Mojo Manual for more information on Mojo value
ownership and value lifecycle management.

7. COPY THE INPUT VECTORS TO GPU MEMORY AND ALLOCATE AN OUTPUT
VECTOR​

Now that we have our input vectors allocated and initialized on the
CPU, let's copy them to the GPU so they'll be available for the kernel
function to use. While we're at it, we'll also allocate memory on the
GPU for the output vector that will hold the result of the kernel
function.

Add the following code to the end of the main() function:

vector_addition.mojo

        # Create DeviceBuffers for the input vectors
        lhs_device_buffer = ctx.enqueue_create_buffer[float_dtype](vector_size)
        rhs_device_buffer = ctx.enqueue_create_buffer[float_dtype](vector_size)

        # Copy the input vectors from the HostBuffers to the DeviceBuffers
        ctx.enqueue_copy(dst_buf=lhs_device_buffer, src_buf=lhs_host_buffer)
        ctx.enqueue_copy(dst_buf=rhs_device_buffer, src_buf=rhs_host_buffer)

        # Create a DeviceBuffer for the result vector
        result_device_buffer = ctx.enqueue_create_buffer[float_dtype](
            vector_size
        )

The DeviceBuffer type is analogous to the HostBuffer type, but
represents a block of device memory associated with a particular
DeviceContext. Specifically, the buffer is located in the device's
_global memory_ space, which is accessible by all threads executing on
the device. As with a HostBuffer, a DeviceBuffer is subject to Mojo's
standard ownership and lifecycle mechanisms. It persists until it is
no longer referenced in the program or until the DeviceContext itself
is destroyed.

The enqueue_create_buffer() method accepts the data type as a
compile-time parameter and the size of the buffer as a run-time
argument and returns a DeviceBuffer. The operation is asynchronous,
but we don't need to call the synchronize() method yet because we have
more operations to add to the queue.

The enqueue_copy() method is overloaded to support copying from host
to device, device to host, or even device to device for systems that
have multiple GPUs. In this example, we use it to copy the data in our
HostBuffers to the DeviceBuffers.

Both DeviceBuffer and HostBuffer also include enqueue_copy_to() and
enqueue_copy_from() methods. These are simply convenience methods that
call the enqueue_copy() method on their corresponding DeviceContext.
Therefore, we could have written the copy operations in the previous
example with the following equivalent code:

    lhs_host_buffer.enqueue_copy_to(dst=lhs_device_buffer)
    rhs_host_buffer.enqueue_copy_to(dst=rhs_device_buffer)

8. CREATE LAYOUTTENSOR VIEWS​

One last step before writing the kernel function is that we're going
to create a LayoutTensor view for each of the vectors. LayoutTensor
provides a powerful abstraction for multi-dimensional data with
precise control over memory organization. It supports various memory
layouts (row-major, column-major, tiled), hardware-specific
optimizations, and efficient parallel access patterns. We don't need
all of these features for this tutorial, but in more complex kernels,
it's a useful tool for manipulating data. Even though it isn't
strictly necessary for this example, we'll use LayoutTensor so that
you can get familiar with it.

First, add the following import to the top of the file:

vector_addition.mojo

from layout import Layout, LayoutTensor

A Layout is a representation of memory layouts using shape and stride
information, and it maps between logical coordinates and linear memory
indices. We'll need to use the same Layout definition multiple times,
so add the following comptime value to the top of the file after the
other comptime declarations:

vector_addition.mojo

comptime layout = Layout.row_major(vector_size)

Finally, add the following code to the end of the main() function to
create LayoutTensor views for each of the vectors:

vector_addition.mojo

        # Wrap the DeviceBuffers in LayoutTensors
        lhs_tensor = LayoutTensor[float_dtype, layout](lhs_device_buffer)
        rhs_tensor = LayoutTensor[float_dtype, layout](rhs_device_buffer)
        result_tensor = LayoutTensor[float_dtype, layout](result_device_buffer)

9. DEFINE THE VECTOR ADDITION KERNEL FUNCTION​

Now we're ready to write the kernel function. First, add the following
imports (note that we've added block_dim to the list of imports from
gpu):

vector_addition.mojo

from gpu import block_dim, block_idx, thread_idx
from math import ceildiv

Then, add the following code to vector_addition.mojo just before the
main() function:

vector_addition.mojo

# Calculate the number of thread blocks needed by dividing the vector size
# by the block size and rounding up.
comptime block_size = 256
comptime num_blocks = ceildiv(vector_size, block_size)

fn vector_addition(
    lhs_tensor: LayoutTensor[float_dtype, layout, MutAnyOrigin],
    rhs_tensor: LayoutTensor[float_dtype, layout, MutAnyOrigin],
    out_tensor: LayoutTensor[float_dtype, layout, MutAnyOrigin],
):
    """Calculate the element-wise sum of two vectors on the GPU."""

    # Calculate the index of the vector element for the thread to process
    var tid = block_idx.x * block_dim.x + thread_idx.x

    # Don't process out of bounds elements
    if tid < vector_size:
        out_tensor[tid] = lhs_tensor[tid] + rhs_tensor[tid]

Our vector_addition() kernel function accepts the two input tensors
and the output tensor as arguments. We also need to know the size of
the vector (which we've defined with the comptime value vector_size)
because it might not be a multiple of the block size. In fact, in this
example, the size of the vector is 1,000, which is not a multiple of
our block size of 256. So as we assign our threads to read elements
from the tensor, we need to make sure we don't overrun the bounds of
the tensor.

The body of the kernel function starts by calculating the linear index
of the tensor element that a particular thread is responsible for. The
block_dim object (which we added to the list of imports) contains the
dimensions of the thread blocks as x, y, and z values. Because we're
going to use a one-dimensional grid of thread blocks, we need only the
x dimension. We can then calculate tid, the unique "global" index of
the thread within the output tensor, as block_dim.x * block_idx.x +
thread_idx.x. For example, the tid values for the threads in the first
thread block range from 0 to 255, the tid values for the threads in
the second thread block range from 256 to 511, and so on.

As a convenience, the gpu package includes a global_idx comptime value
that contains the unique "global" x, y, and z indices of the thread
within the grid of thread blocks. So for our one-dimensional grid of
one-dimensional thread blocks, global_idx.x is equivalent to the value
of tid that we calculated above. However, for this tutorial, it's best
that you learn how to calculate tid manually so that you understand
how the grid and thread block dimensions work.

The function then checks if the calculated tid is less than the size
of the output tensor. If it is, the thread reads the corresponding
elements from the lhs_tensor and rhs_tensor tensors, adds them
together, and stores the result in the corresponding element of the
out_tensor tensor.

10. INVOKE THE KERNEL FUNCTION AND COPY THE OUTPUT BACK TO THE CPU​

The last step is to compile and invoke the kernel function, then copy
the output back to the CPU. Add the following code to the end of the
main() function:

vector_addition.mojo

        # Compile and enqueue the kernel
        ctx.enqueue_function_checked[vector_addition, vector_addition](
            lhs_tensor,
            rhs_tensor,
            result_tensor,
            grid_dim=num_blocks,
            block_dim=block_size,
        )

        # Create a HostBuffer for the result vector
        result_host_buffer = ctx.enqueue_create_host_buffer[float_dtype](
            vector_size
        )

        # Copy the result vector from the DeviceBuffer to the HostBuffer
        ctx.enqueue_copy(
            dst_buf=result_host_buffer, src_buf=result_device_buffer
        )

        # Finally, synchronize the DeviceContext to run all enqueued operations
        ctx.synchronize()

        print("Result vector:", result_host_buffer)

Click here to see the complete version of vector_addition.mojo.

The enqueue_function_checked() method enqueues the compilation and
invocation of the vector_addition() kernel function, passing the input
and output tensors as arguments. The grid_dim and block_dim arguments
use the num_blocks and block_size comptime values we defined in the
previous step.

After the kernel function has been compiled and enqueued, we create a
HostBuffer to hold the result vector. Then we copy the result vector
from the DeviceBuffer to the HostBuffer. Finally, we synchronize the
DeviceContext to run all enqueued operations. After synchronizing, we
can print the result vector to the console.

At this point, the Mojo compiler determines that the DeviceContext,
the DeviceBuffers, the HostBuffers, and the LayoutTensors are no
longer used and so it automatically invokes their destructors to free
their allocated memory. (For a detailed explanation of object lifetime
and destruction in Mojo, see the Death of a value section of the Mojo
Manual.)

Now it's time to run the program to see the results of our work.

mojo vector_addition.mojo

You should see the following output:

LHS buffer:  HostBuffer([0.0, 1.0, 2.0, ..., 997.0, 998.0, 999.0])
RHS buffer:  HostBuffer([0.0, 0.5, 1.0, ..., 498.5, 499.0, 499.5])
Result vector: HostBuffer([0.0, 1.5, 3.0, ..., 1495.5, 1497.0, 1498.5])

And now that you're done with the tutorial, exit your project's
virtual environment:

SUMMARY​

In this tutorial, we've learned how to use Mojo's gpu.host package to
write a simple kernel function that performs an element-wise addition
of two vectors. We covered:

 	* Understanding basic GPU concepts like devices, grids, and thread
blocks.
 	* Moving data between CPU and GPU memory.
 	* Writing and compiling a GPU kernel function.
 	* Executing parallel computations on the GPU.

MOJO LANGUAGE BASICS | MODULAR

This page provides an overview of the Mojo language.

If you know Python, then a lot of Mojo code will look familiar.
However, Mojo incorporates features like static type checking, memory
safety, next-generation compiler technologies, and more. As such, Mojo
also has a lot in common with languages like C++ and Rust.

If you prefer to learn by doing, follow the Get started with Mojo
tutorial.

On this page, we'll introduce the essential Mojo syntax, so you can
start coding quickly and understand other Mojo code you encounter.
Subsequent sections in the Mojo Manual dive deeper into these topics,
and links are provided below as appropriate.

Let's get started! 🔥

Mojo is a young language and there are many features still missing. As
such, Mojo is currently NOT meant for beginners. Even this basics
section assumes some programming experience. However, throughout the
Mojo Manual, we try not to assume experience with any particular
language.

HELLO WORLD​

Here's the traditional "Hello world" program in Mojo:

def main():
    print("Hello, world!")

Every Mojo program must include a function named main() as the entry
point. We'll talk more about functions soon, but for now it's enough
to know that you can write def main(): followed by an indented
function body.

The print() statement does what you'd expect, printing its arguments
to the standard output.

VARIABLES​

In Mojo, you can declare a variable by simply assigning a value to a
new named variable:

def main():
    x = 10
    y = x * x
    print(y)

You can also _explicitly_ declare variables with the var keyword:

var x = 10

When declaring a variable with var, you can also declare a variable
type, with or without an assignment:

def main():
    var x: Int = 10
    var sum: Int
    sum = x + x

Both implicitly declared and explicitly declared variables are
statically typed: that is, the type is set at compile time, and
doesn't change at runtime. If you don't specify a type, Mojo uses the
type of the first value assigned to the variable.

x = 10
x = "Foo" # Error: Cannot convert "StringLiteral" value to "Int"

For more details, see the page about variables.

BLOCKS AND STATEMENTS​

Code blocks such as functions, conditions, and loops are defined with
a colon followed by indented lines. For example:

def loop():
    for x in range(5):
        if x % 2 == 0:
            print(x)

You can use any number of spaces or tabs for your indentation (we
prefer 4 spaces).

All code statements in Mojo end with a newline. However, statements
can span multiple lines if you indent the following lines. For
example, this long string spans two lines:

def print_line():
    long_text = "This is a long line of text that is a lot easier to read if"
                " it is broken up across two lines instead of one long line."
    print(long_text)

And you can chain function calls across lines:

def print_hello():
    text = ",".join("Hello", " world!")
    print(text)

For more information on loops and conditional statements, see Control
flow.

FUNCTIONS​

You can define a Mojo function using either the def or fn keyword. For
example, the following uses the def keyword to define a function named
greet that requires a single String argument and returns a String:

def greet(name: String) -> String:
    return "Hello, " + name + "!"

Where def and fn differ is error handling and argument mutability
defaults. Refer to the Functions page for more details on defining and
calling functions.

You can create a one-line comment using the hash # symbol:

# This is a comment. The Mojo compiler ignores this line.

Comments may also follow some code:

var message = "Hello, World!" # This is also a valid comment

API documentation comments are enclosed in triple quotes. For example:

fn print(x: String):
    """Prints a string.

    Args:
        x: The string to print.
    """
    ...

Documenting your code with these kinds of comments (known as
"docstrings") is a topic we've yet to fully specify, but you can
generate an API reference from docstrings using the mojo doc command.

Technically, docstrings aren't _comments_, they're a special use of
Mojo's syntax for multi-line string literals. For details, see String
literals in the page on Types.

STRUCTS​

You can build high-level abstractions for types (or "objects") as a
struct.

A struct in Mojo is similar to a class in Python: they both support
methods, fields, operator overloading, decorators for metaprogramming,
and so on. However, Mojo structs are completely static—they are
bound at compile-time, so they do not allow dynamic dispatch or any
runtime changes to the structure. (Mojo will also support Python-style
classes in the future.)

For example, here's a basic struct:

struct MyPair(Copyable):
    var first: Int
    var second: Int

    fn __init__(out self, first: Int, second: Int):
        self.first = first
        self.second = second

    fn __copyinit__(out self, existing: Self):
        self.first = existing.first
        self.second = existing.second

    def dump(self):
        print(self.first, self.second)

And here's how you can use it:

def use_mypair():
    var mine = MyPair(2, 4)
    mine.dump()

Note that some functions are declared with fn function, while the
dump() function is declared with def. In general, you can use either
form in a struct.

The MyPair struct contains two special methods, __init__(), the
constructor, and __copyinit__(), the copy constructor. _Lifecycle
methods_ like this control how a struct is created, copied, moved, and
destroyed.

For most simple types, you don't need to write the lifecycle methods.
You can use the @fieldwise_init decorator to generate the boilerplate
field-wise initializer for you, and Mojo will synthesize copy and move
constructors if you ask for them with trait conformance. So the MyPair
struct can be simplified to this:

@fieldwise_init
struct MyPair(Copyable):
    var first: Int
    var second: Int

    def dump(self):
        print(self.first, self.second)

For more details, see the page about structs.

TRAITS​

A trait is like a template of characteristics for a struct. If you
want to create a struct with the characteristics defined in a trait,
you must implement each characteristic (such as each method). Each
characteristic in a trait is a "requirement" for the struct, and when
your struct implements all of the requirements, it's said to "conform"
to the trait.

Using traits allows you to write generic functions that can accept any
type that conforms to a trait, rather than accept only specific types.

For example, here's how you can create a trait:

trait SomeTrait:
    fn required_method(self, x: Int): ...

The three dots following the method signature are Mojo syntax
indicating that the method is not implemented.

Here's a struct that conforms to SomeTrait:

@fieldwise_init
struct SomeStruct(SomeTrait):
    fn required_method(self, x: Int):
        print("hello traits", x)

Then, here's a function that uses the trait as an argument type
(instead of the struct type):

fn fun_with_traits[T: SomeTrait](x: T):
    x.required_method(42)

fn use_trait_function():
    var thing = SomeStruct()
    fun_with_traits(thing)

You'll see traits used in a lot of APIs provided by Mojo's standard
library. For example, Mojo's collection types like List and Dict can
store any type that conforms to the Copyable trait. You can specify
the type when you create a collection:

my_list = List[Float64]()

You're probably wondering about the square brackets on
fun_with_traits(). These aren't function _arguments_ (which go in
parentheses); these are function _parameters_, which we'll explain
next.

Without traits, the x argument in fun_with_traits() would have to
declare a specific type that implements required_method(), such as
SomeStruct (but then the function would accept only that type). With
traits, the function can accept any type for x as long as it conforms
to (it "implements") SomeTrait. Thus, fun_with_traits() is known as a
"generic function" because it accepts a _generalized_ type instead of
a specific type.

For more details, see the page about traits.

PARAMETERIZATION​

In Mojo, a parameter is a compile-time variable that becomes a runtime
constant, and it's declared in square brackets on a function or
struct. Parameters allow for compile-time metaprogramming, which means
you can generate or modify code at compile time.

Many other languages use "parameter" and "argument" interchangeably,
so be aware that when we say things like "parameter" and "parametric
function," we're talking about these compile-time parameters. Whereas,
a function "argument" is a runtime value that's declared in
parentheses.

Parameterization is a complex topic that's covered in much more detail
in the Metaprogramming section, but we want to break the ice just a
little bit here. To get you started, let's look at a parametric
function:

def repeat[count: Int](msg: String):
    @parameter # evaluate the following for loop at compile time
    for i in range(count):
        print(msg)

This function has one parameter of type Int and one argument of type
String. To call the function, you need to specify both the parameter
and the argument:

def call_repeat():
    repeat[3]("Hello")
    # Prints "Hello" 3 times

By specifying count as a parameter, the Mojo compiler is able to
optimize the function because this value is guaranteed to not change
at runtime. And the @parameter decorator in the code tells the
compiler to evaluate the for loop at compile time, not runtime.

The compiler effectively generates a unique version of the repeat()
function that repeats the message only 3 times. This makes the code
more performant because there's less to compute at runtime.

Similarly, you can define a struct with parameters, which effectively
allows you to define variants of that type at compile-time, depending
on the parameter values.

For more detail on parameters, see the section on Metaprogramming.

PYTHON INTEGRATION​

Mojo supports the ability to import Python modules as-is, so you can
leverage existing Python code right away.

For example, here's how you can import and use NumPy:

from python import Python

def main():
    var np = Python.import_module("numpy")
    var ar = np.arange(15).reshape(3, 5)
    print(ar)
    print(ar.shape)

You must have the Python module (such as numpy) installed in the
environment where you're using Mojo.

For more details, see the page on Python integration.

NEXT STEPS​

Hopefully this page has given you enough information to start
experimenting with Mojo, but this is only touching the surface of
what's available in Mojo.

If you're in the mood to read more, continue through each page of this
Mojo Manual—the next page from here is Functions.

Otherwise, here are some other resources to check out:

 	*
See Get started with Mojo for a hands-on tutorial that will get you up
and running with Mojo.

 	*
If you want to experiment with some code, clone our GitHub repo to try
our code examples:

git clone https://github.com/modular/modular.git

cd max/examples/mojo

 	*
To see all the available Mojo APIs, check out the Mojo standard
library reference.

FUNCTIONS | MODULAR

As mentioned in the syntax overview, Mojo supports two keywords to
declare functions: def and fn. You can use either declaration with any
function, including the main() function, but they have different
default behaviors, as described on this page.

We believe both def and fn have good use cases and don't consider
either to be better than the other. Deciding which to use is a matter
of personal taste as to which style best fits a given task.

Functions declared inside a struct are called "methods," but they have
all the same qualities as "functions" described here.

ANATOMY OF A FUNCTION​

Both def and fn function declarations have the same basic components
(here demonstrated with a def function):

DEF function_name[ ​    parameters ... ]( ​    arguments ... ) -> return_value_type: ​    function_body

Functions can have:

 	* Parameters: A function can optionally take one or more
compile-time _parameter_ values used for metaprogramming.
 	* Arguments: A function can also optionally take one or more
run-time _arguments_.
 	* Return value: A function can optionally return a value.
 	* Function body: Statements that are executed when you call the
function. Function definitions must include a body.

All of the optional parts of the function can be omitted, so the
minimal function is something like this:

def do_nothing():
    pass

If a function takes no parameters, you can omit the square brackets,
but the parentheses are always required.

Although you can't leave out the function body, you can use the pass
statement to define a function that does nothing.

ARGUMENTS AND PARAMETERS​

Functions take two kinds of inputs: _arguments_ and _parameters_.
Arguments are familiar from many other languages: they are run-time
values passed into the function.

def add(a: Int, b: Int) -> Int:
    return a+b

On the other hand, you can think of a parameter as a compile-time
variable that becomes a run-time constant. For example, consider the
following function with a parameter:

def add_tensors[rank: Int](a: MyTensor[rank], b: MyTensor[rank]) -> MyTensor[rank]:
    # ...

In this case, the rank value needs to be specified in a way that can
be determined at compilation time, such as a literal or expression.

When you compile a program that uses this code, the compiler produces
a unique version of the function for each unique rank value used in
the program, with rank treated as a constant within each specialized
version.

This usage of "parameter" is probably different from what you're used
to from other languages, where "parameter" and "argument" are often
used interchangeably. In Mojo, "parameter" and "parameter expression"
refer to compile-time values, and "argument" and "expression" refer to
run-time values.

By default, both arguments and parameters can be specified either by
position or by keyword. These forms can also be mixed in the same
function call.

# positional
x = add(5, 7)      # Positionally, a=5 and b=7
# keyword
y = add(b=3, a=9)
# mixed
z = add(5, b=7)    # Positionally, a=5

For more information on arguments, see Function arguments on this
page. For more information on parameters, see Parameterization:
compile-time metaprogramming.

DEF AND FN COMPARISON​

Defining a function using def and fn have much in common. They both
have the following requirements:

 	*
You must declare the type of each function parameter and argument.

 	*
If a function doesn't return a value, you can either omit the return
type or declare None as the return type.

# The following function definitions are equivalent

def greet(name: String):
  print("Hello," name)

def greet(name: String) -> None:
  print("Hello," name)

 	*
If the function returns a value, you must either declare the return
type using the -> type syntax or provide a named result in the
argument list.

# The following function definitions are equivalent

def incr(a: Int) -> Int:
  return a + 1

def incr(a: Int, out b: Int):
  b = a + 1

For more information, see the Return values section of this page.

Where def and fn differ is error handling.

 	* The compiler doesn't allow a function declared with fn to raise an
error condition unless it explicitly includes a raises declaration. In
contrast, the compiler assumes that _all_ functions declared with def
_might_ raise an error. See the Raising and non-raising functions
section of this page for more information.

As far as a function caller is concerned, there is no difference
between invoking a function declared with def vs a function declared
with fn. You could reimplement a def function as an fn function
without making any changes to code that calls the function.

FUNCTION ARGUMENTS​

The rules for arguments described in this section apply to both def
and fn functions.

Functions with / and * in the argument list

You might see the following characters in place of arguments: slash
(/) and/or star (*). For example:

def myfunc(pos_only, /, pos_or_keyword, *, keyword_only):

Arguments BEFORE the / can be passed only by position. Arguments AFTER
the * can be passed only by keyword. For details, see Positional-only
and keyword-only arguments

You may also see argument names prefixed with one or two stars (*):

def myfunc2(*names, **attributes):

An argument name prefixed by a single star character, like *names
identifies a variadic argument, while an argument name prefixed with a
double star, like **attributes identifies a variadic keyword-only
argument.

OPTIONAL ARGUMENTS​

An optional argument is one that includes a default value, such as the
exp argument here:

fn my_pow(base: Int, exp: Int = 2) -> Int:
    return base ** exp

fn use_defaults():
    # Uses the default value for `exp`
    var z = my_pow(3)
    print(z)

However, you can't define a default value for an argument that's
declared with the mut argument convention.

Any optional arguments must appear after any required arguments.
Keyword-only arguments, discussed later, can also be either required
or optional.

KEYWORD ARGUMENTS​

You can also use keyword arguments when calling a function. Keyword
arguments are specified using the format argument_name =
argument_value. You can pass keyword arguments in any order:

fn my_pow(base: Int, exp: Int = 2) -> Int:
    return base ** exp

fn use_keywords():
    # Uses keyword argument names (with order reversed)
    var z = my_pow(exp=3, base=2)
    print(z)

VARIADIC ARGUMENTS​

Variadic arguments let a function accept a variable number of
arguments. To define a function that takes a variadic argument, use
the variadic argument syntax *argument_name:

fn sum(*values: Int) -> Int:
  var sum: Int = 0
  for value in values:
    sum = sum + value
  return sum

The variadic argument values here is a placeholder that accepts any
number of passed positional arguments.

You can define zero or more arguments before the variadic argument.
When calling the function, any remaining positional arguments are
assigned to the variadic argument, so any arguments declared AFTER the
variadic argument can only be specified by keyword (see
Positional-only and keyword-only arguments).

Variadic arguments can be divided into two categories:

 	* Homogeneous variadic arguments, where all of the passed arguments
are the same type—all Int, or all String, for example.
 	* Heterogeneous variadic arguments, which can accept a set of
different argument types.

The following sections describe how to work with homogeneous and
heterogeneous variadic arguments.

Variadic parameters

Mojo also supports variadic _parameters_, but with some
limitations—for details see variadic parameters.

HOMOGENEOUS VARIADIC ARGUMENTS​

When defining a homogeneous variadic argument (all arguments must be
the same type), use *argument_name: argument_type:

def greet(*names: String):
    ...

Inside the function body, the variadic argument is available as an
iterable list for ease of use. Currently there are some differences in
handling the list depending on whether the arguments are
register-passable types (such as Int) or memory-only types (such as
String).

TODO

We hope to remove these differences in the future.

Register-passable types, such as Int, are available as a VariadicList
type. As shown in the previous example, you can iterate over the
values using a for..in loop.

fn sum(*values: Int) -> Int:
  var sum: Int = 0
  for value in values:
    sum = sum+value
  return sum

Memory-only types, such as String, are available as a VariadicListMem.
Iterating over this list directly with a for..in loop currently
produces a reference to the element, which can be mutable with a mut
variadic list. Use the ref binding pattern to capture a mutable
reference if you want to mutate the elements of the list:

def make_worldly(mut *strs: String):
    for ref i in strs:
        i += " world"

You can also directly index the list with integers as well:

fn make_worldly(mut *strs: String):
    for i in range(len(strs)):
        strs[i] += " world"

HETEROGENEOUS VARIADIC ARGUMENTS​

Implementing heterogeneous variadic arguments (each argument type may
be different) is somewhat more complicated than homogeneous variadic
arguments. To handle multiple argument types, the function must be
generic, which requires using traits and parameters. So the syntax may
look a little unfamiliar if you haven't worked with those features.

The signature for a function with a heterogeneous variadic argument
looks like this:

def count_many_things[*ArgTypes: Intable](*args: *ArgTypes):
    ...

The parameter list, [*ArgTypes: Intable] specifies that the function
takes an ArgTypes parameter, which is a list of types, all of which
conform to the Intable trait. The asterisk in *ArgTypes indicates that
ArgTypes is a VARIADIC TYPE PARAMETER (a list of types).

The argument list, (*args: *ArgTypes) has the familiar *args for the
variadic argument, but instead of a single type, its type is defined
as the variadic type list *ArgTypes. The asterisk in *args indicates a
VARIADIC ARGUMENT, and the asterisk in *ArgTypes refers to the
variadic type parameter.

This means that each argument in args has a corresponding type in
ArgTypes, so args[n] is of type ArgTypes[n].

Inside the function, args becomes a VariadicPack because the syntax
*args: *ArgTypes creates a heterogeneous variadic argument. That means
each element in args can be a different type that requires a different
amount of memory. To iterate through the VariadicPack, the compiler
must know each element's type (its memory size), so you must use a
parametric for loop:

fn count_many_things[*ArgTypes: Intable](*args: *ArgTypes) -> Int:
    var total = 0

    @parameter
    for i in range(args.__len__()):
        total += Int(args[i])

    return total

def main():
    print(count_many_things(5, 11.7, 12))

Notice that when calling count_many_things(), you don't actually pass
in a list of argument types. You only need to pass in the arguments,
and Mojo generates the ArgTypes list itself.

VARIADIC KEYWORD ARGUMENTS​

Mojo functions also support variadic keyword arguments (**kwargs).
Variadic keyword arguments allow the user to pass an arbitrary number
of keyword arguments. To define a function that takes a variadic
keyword argument, use the variadic keyword argument syntax
**kw_argument_name:

fn print_nicely(**kwargs: Int) raises:
  for key in kwargs.keys():
      print(key, "=", kwargs[key])

 # prints:
 # `a = 7`
 # `y = 8`
print_nicely(a=7, y=8)

In this example, the argument name kwargs is a placeholder that
accepts any number of keyword arguments. Inside the body of the
function, you can access the arguments as a dictionary of keywords and
argument values (specifically, an instance of OwnedKwargsDict).

There are currently a few limitations:

 	*
Variadic keyword arguments are always implicitly treated as if they
were declared with the owned argument convention, and can't be
declared otherwise:

# Not supported yet.
fn read_var_kwargs(read **kwargs: Int): ...

 	*
All the variadic keyword arguments must have the same type, and this
determines the type of the argument dictionary. For example, if the
argument is **kwargs: Float64 then the argument dictionary will be a
OwnedKwargsDict[Float64].

 	*
The argument type must conform to the Copyable trait.

 	*
Dictionary unpacking is not supported yet:

fn takes_dict(d: Dict[String, Int]):
  print_nicely(**d)  # Not supported yet.

 	*
Variadic keyword _parameters_ are not supported yet:

# Not supported yet.
fn var_kwparams[**kwparams: Int](): ...

POSITIONAL-ONLY AND KEYWORD-ONLY ARGUMENTS​

When defining a function, you can restrict some arguments so that they
can be passed only as positional arguments, or they can be passed only
as keyword arguments.

To define positional-only arguments, add a slash character (/) to the
argument list. Any arguments before the / are positional-only: they
can't be passed as keyword arguments. For example:

fn min(a: Int, b: Int, /) -> Int:
    return a if a < b else b

This min() function can be called with min(1, 2) but can't be called
using keywords, like min(a=1, b=2).

There are several reasons you might want to write a function with
positional-only arguments:

 	* The argument names aren't meaningful for the caller.
 	* You want the freedom to change the argument names later on without
breaking backward compatibility.

For example, in the min() function, the argument names don't add any
real information, and there's no reason to specify arguments by
keyword.

For more information on positional-only arguments, see PEP 570 –
Python Positional-Only Parameters.

Keyword-only arguments are the inverse of positional-only arguments:
they can be specified only by keyword. If a function accepts variadic
arguments, any arguments defined _after_ the variadic arguments are
treated as keyword-only. For example:

fn sort(*values: Float64, ascending: Bool = True): ...

In this example, the user can pass any number of Float64 values,
optionally followed by the keyword ascending argument:

var a = sort(1.1, 6.5, 4.3, ascending=False)

If the function doesn't accept variadic arguments, you can add a
single star (*) to the argument list to separate the keyword-only
arguments:

fn kw_only_args(a1: Int, a2: Int, *, double: Bool) -> Int:
    var product = a1 * a2
    if double:
        return product * 2
    else:
        return product

Keyword-only arguments often have default values, but this is not
required. If a keyword-only argument doesn't have a default value, it
is a _required keyword-only argument_. It must be specified, and it
must be specified by keyword.

Any required keyword-only arguments must appear in the signature
before any optional keyword-only arguments. That is, arguments appear
in the following sequence a function signature:

 	* Required positional arguments.
 	* Optional positional arguments.
 	* Variadic arguments.
 	* Required keyword-only arguments.
 	* Optional keyword-only arguments.
 	* Variadic keyword arguments.

For more information on keyword-only arguments, see PEP 3102 –
Keyword-Only Arguments.

OVERLOADED FUNCTIONS​

All function declarations must specify argument types, so if you want
a function to work with different data types, you need to implement
separate versions of the function that each specify different argument
types. This is called "overloading" a function.

For example, here's an overloaded add() function that can accept
either Int or String types:

fn add(x: Int, y: Int) -> Int:
    return x + y

fn add(x: String, y: String) -> String:
    return x + y

If you pass anything other than Int or String to the add() function,
you'll get a compiler error. That is, unless Int or String can
implicitly cast the type into their own type. For example, String
includes an overloaded version of its constructor (__init__()) that
supports implicit conversion from a StringLiteral value. Thus, you can
also pass a StringLiteral to a function that expects a String.

When resolving an overloaded function call, the Mojo compiler tries
each candidate function and uses the one that works (if only one
version works), or it picks the closest match (if it can determine a
close match), or it reports that the call is ambiguous (if it can't
figure out which one to pick). For details on how Mojo picks the best
candidate, see Overload resolution.

If the compiler can't figure out which function to use, you can
resolve the ambiguity by explicitly casting your value to a supported
argument type. For example, the following code calls the overloaded
foo() function, but both implementations accept an argument that
supports implicit conversion from StringLiteral. So, the call to
foo(string) is ambiguous and creates a compiler error. You can fix
this by casting the value to the type you really want:

struct MyString:
    @implicit
    fn __init__(out self, string: StringLiteral):
        pass

fn foo(name: String):
    print("String")

fn foo(name: MyString):
    print("MyString")

fn call_foo():
    comptime string = "Hello"
    # foo(string) # error: ambiguous call to 'foo' ... This call is ambiguous because two `foo` functions match it
    foo(MyString(string))

Overloading also works with combinations of both fn and def function
declarations.

OVERLOAD RESOLUTION​

When resolving an overloaded function, Mojo does not consider the
return type or other contextual information at the call site—it
considers only parameter and argument types and whether the functions
are instance methods or static methods.

The overload resolution logic filters for candidates according to the
following rules, in order of precedence:

 	* Candidates requiring the smallest number of implicit conversions
(in both arguments and parameters).
 	* Candidates without variadic arguments.
 	* Candidates without variadic parameters.
 	* Candidates with the shortest parameter signature.
 	* Non-@staticmethod candidates (over @staticmethod ones, if
available).

If there is more than one candidate after applying these rules, the
overload resolution fails. For example:

@register_passable("trivial")
struct MyInt:
    """A type that is implicitly convertible to `Int`."""
    var value: Int

    @implicit
    fn __init__(out self, _a: Int):
        self.value = _a

fn foo[x: MyInt, a: Int]():
    print("foo[x: MyInt, a: Int]()")

fn foo[x: MyInt, y: MyInt]():
    print("foo[x: MyInt, y: MyInt]()")

fn bar[a: Int](b: Int):
    print("bar[a: Int](b: Int)")

fn bar[a: Int](*b: Int):
    print("bar[a: Int](*b: Int)")

fn bar[*a: Int](b: Int):
    print("bar[*a: Int](b: Int)")

fn parameter_overloads[a: Int, b: Int, x: MyInt]():
    # `foo[x: MyInt, a: Int]()` is called because it requires no implicit
    # conversions, whereas `foo[x: MyInt, y: MyInt]()` requires one.
    foo[x, a]()

    # `bar[a: Int](b: Int)` is called because it does not have variadic
    # arguments or parameters.
    bar[a](b)

    # `bar[*a: Int](b: Int)` is called because it has variadic parameters.
    bar[a, a, a](b)

parameter_overloads[1, 2, MyInt(3)]()

struct MyStruct:
    fn __init__(out self):
        pass

    fn foo(mut self):
        print("calling instance method")

    @staticmethod
    fn foo():
        print("calling static method")

fn test_static_overload():
    var a = MyStruct()
    # `foo(mut self)` takes precedence over a static method.
    a.foo()

foo[x: MyInt, a: Int]()
bar[a: Int](b: Int)
bar[*a: Int](b: Int)

RETURN VALUES​

Return value types are declared in the signature using the -> type
syntax. Values are passed using the return keyword, which ends the
function and returns the identified value (if any) to the caller.

def get_greeting() -> String:
    return "Hello"

By default, the value is returned to the caller as an owned value. As
with arguments, a return value may be implicitly converted to the
named return type. For example, the previous example calls return with
a string literal, "Hello", which is implicitly converted to a String.

NAMED RESULTS​

Named function results allow a function to return a value that can't
be moved or copied. Named result syntax lets you specify a named,
uninitialized variable to return to the caller using the out argument
convention:

def get_name_tag(var name: String, out name_tag: NameTag):
    name_tag = NameTag(name^)

The out argument convention identifies an uninitialized variable that
the function must initialize. (This is the same as the out convention
used in struct constructors.) The out argument for a named result can
appear anywhere in the argument list, but by convention, it should be
the last argument in the list.

A function can declare only one return value, whether it's declared
using an out argument or using the standard -> type syntax.

A function with a named result argument doesn't need to include an
explicit return statement, as shown above. If the function terminates
without a return, or at a return statement with no value, the value of
the out argument is returned to the caller. If it includes a return
statement with a value, that value is returned to the caller, as
usual.

The fact that a function uses a named result is transparent to the
caller. That is, these two signatures are interchangeable to the
caller:

def get_name_tag(var name: String) -> NameTag:
    ...
def get_name_tag(var name: String, out name_tag: NameTag):
    ...

In both cases, the call looks like this:

tag = get_name_tag("Judith")

Because the return value is assigned to this special out variable, it
doesn't need to be moved or copied when it's returned to the caller.
This means that you can create a function that returns a type that
can't be moved or copied, and which takes several steps to initialize:

struct ImmovableObject:
    var name: String

    fn __init__(out self, var name: String):
        self.name = name^

def create_immovable_object(var name: String, out obj: ImmovableObject):
    obj = ImmovableObject(name^)
    obj.name += "!"
    # obj is implicitly returned

def main():
    my_obj = create_immovable_object("Blob")

By contrast, the following function with a standard return value
doesn't work:

def create_immovable_object2(var name: String) -> ImmovableObject:
    obj = ImmovableObject(name^)
    obj.name += "!"
    return obj^ # Error: ImmovableObject is not copyable or movable

Because create_immovable_object2 uses a local variable to store the
object while it's under construction, the return call requires it to
be either moved or copied to the callee. This isn't an issue if the
newly-created value is returned immediately:

def create_immovable_object3(var name: String) -> ImmovableObject:
    return ImmovableObject(name^) # OK

RAISING AND NON-RAISING FUNCTIONS​

By default, when a function raises an error, the function terminates
immediately and the error propagates to the calling function. If the
calling function doesn't handle the error, it continues to propagate
up the call stack.

def raises_error():
    raise Error("There was an error.")

The Mojo compiler _always_ treats a function declared with def as a
_raising function_, even if the body of the function doesn't contain
any code that could raise an error.

Functions declared with fn without the raises keyword are _non-raising
functions_—that is, they are not allowed to propagate an error to
the calling function. If a non-raising function calls a raising
function, it MUST HANDLE ANY POSSIBLE ERRORS.

# This function will not compile
fn unhandled_error():
    raises_error()   # Error: can't call raising function in a non-raising context

# Explicitly handle the error
fn handle_error():
    try:
        raises_error()
    except e:
        print("Handled an error:", e)

# Explicitly propagate the error
fn propagate_error() raises:
    raises_error()

If you're writing code that you expect to use widely or distribute as
a package, you may want to use fn functions for APIs that don't raise
errors to limit the number of places users need to add unnecessary
error handling code. For some extremely performance-sensitive code, it
may be preferable to avoid run-time error-handling.


VARIABLES

A variable is a name that holds a value or object. All variables in
Mojo are mutable—their value can be changed. (If you want to define
a constant value that can't change at runtime, see the comptime
keyword.)

When you declare a variable in Mojo, you allocate a logical storage
location, and bind a name to that storage location.

var greeting: String = "Hello World"

The var statement above does three things:

 	* It declares a logical storage location (in this case, a storage
location sized to hold a String struct).
 	* It binds the name greeting to this logical storage location.
 	* It _initializes_ the storage space with a newly-created String
value, with the text, “Hello World”. The new value is _owned by_
the variable. No other variable can own this value unless we
intentionally transfer it.

VARIABLE DECLARATIONS​

Mojo has two ways to declare a variable:

 	*
Explicitly-declared variables are created with the var keyword.

var a = 5
var b: Float64 = 3.14
var c: String

 	*
Implicitly-declared variables are created the first time the variable
is used, either with an assignment statement, or with a type
annotation:

a = 5
b: Float64 = 3.14
c: String

Both types of variables are strongly typed—the type is either set
explicitly with a type annotation or implicitly when the variable is
first initialized with a value.

Either way, the variable receives a type when it's created, and the
type never changes. So you can't assign a variable a value of a
different type:

count = 8 # count is type Int
count = "Nine?" # Error: can't implicitly convert 'StringLiteral' to 'Int'

Some types support _implicit conversions_ from other types. For
example, an integer value can implicitly convert to a floating-point
value:

var temperature: Float64 = 99
print(temperature)

In this example, the temperature variable is explicitly typed as
Float64, but assigned an integer value, so the value is implicitly
converted to a Float64.

IMPLICITLY-DECLARED VARIABLES​

You can create a variable with just a name and a value. For example:

name = "Sam"
user_id = 0

Implicitly-declared variables are strongly typed: they take the type
from the first value assigned to them. For example, the user_id
variable above is type Int, while the name variable is type String.
You can't assign a string to user_id or an integer to name.

You can also use a type annotation with an implicitly-declared
variable, either as part of an assignment statement, or on its own:

name: String = "Sam"
user_id: Int

Here the user_id variable has a type, but is uninitialized.

Implicitly-declared variables are scoped at the function level. You
create an implicitly-declared variable the first time you assign a
value to a given name inside a function. Any subsequent references to
that name inside the function refer to the same variable. For more
information, see Variable scopes, which describes how variable scoping
differs between explicitly- and implicitly-declared variables.

EXPLICITLY-DECLARED VARIABLES​

You can declare a variable with the var keyword. For example:

var name = "Sam"
var user_id: Int

The name variable is initialized to the string "Sam". The user_id
variable is uninitialized, but it has a declared type, Int for an
integer value.

Since variables are strongly typed, you can't assign a variable a
value of a different type, unless those types can be implicitly
converted. For example, this code will not compile:

var user_id: Int = "Sam"

Explicitly-declared variables follow lexical scoping, unlike
implicitly-declared variables.

TYPE ANNOTATIONS​

Although Mojo can infer a variable type from the first value assigned
to a variable, it also supports static type annotations on variables.
Type annotations provide a more explicit way of specifying the
variable's type.

To specify the type for a variable, add a colon followed by the type
name:

var name: String = get_name()
# Or
name: String = get_name()

This makes it clear that name is type String, without knowing what the
get_name() function returns. The get_name() function may return a
String, or a value that's implicitly convertible to a String.

If a type has a constructor with just one argument, you can initialize
it in two ways:

var name1: String = "Sam"
var name2 = String("Sam")
var name3 = "Sam"

All of these lines invoke the same constructor to create a String from
a StringLiteral.

LATE INITIALIZATION​

Using type annotations allows for late initialization. For example,
notice here that the z variable is first declared with just a type,
and the value is assigned later:

fn my_function(x: Int):
    var z: Float32
    if x != 0:
        z = 1.0
    else:
        z = foo()
    print(z)

fn foo() -> Float32:
    return 3.14

If you try to pass an uninitialized variable to a function or use it
on the right-hand side of an assignment statement, compilation fails.

var z: Float32
var y = z # Error: use of uninitialized value 'z'

Late initialization works only if the variable is declared with a
type.

IMPLICIT TYPE CONVERSION​

Some types include built-in type conversion (type casting) from one
type into its own type. For example, if you assign an integer to a
variable that has a floating-point type, it converts the value instead
of giving a compiler error:

var number: Float64 = Int(1)
print(number)

As shown above, value assignment can be converted into a constructor
call if the target type has a constructor that meets the following
criteria:

So, this code uses the Float64 constructor that takes an integer:
__init__(out self, value: Int).

In general, implicit conversions should only be supported where the
conversion is lossless.

Implicit conversion follows the logic of overloaded functions. If the
destination type has a viable implicit conversion constructor for the
source type, it can be invoked for implicit conversion.

So assigning an integer to a Float64 variable is exactly the same as
this:

var number = Float64(1)

Similarly, if you call a function that requires an argument of a
certain type (such as Float64), you can pass in any value as long as
that value type can implicitly convert to the required type (using one
of the type's overloaded constructors).

For example, you can pass an Int to a function that expects a Float64,
because Float64 includes an implicit conversion constructor that takes
an Int:

fn take_float(value: Float64):
    print(value)

fn pass_integer():
    var value: Int = 1
    take_float(value)

For more details on implicit conversion, see Constructors and implicit
conversion.

VARIABLE SCOPES​

Variables declared with var are bound by _lexical scoping_. This means
that nested code blocks can read and modify variables defined in an
outer scope. But an outer scope CANNOT read variables defined in an
inner scope at all.

For example, the if code block shown here creates an inner scope where
outer variables are accessible to read/write, but any new variables do
not live beyond the scope of the if block:

def lexical_scopes():
    var num = 1
    var dig = 1
    if num == 1:
        print("num:", num)  # Reads the outer-scope "num"
        var num = 2         # Creates new inner-scope "num"
        print("num:", num)  # Reads the inner-scope "num"
        dig = 2             # Updates the outer-scope "dig"
    print("num:", num)      # Reads the outer-scope "num"
    print("dig:", dig)      # Reads the outer-scope "dig"

num: 1
num: 2
num: 1
dig: 2

Note that the var statement inside the if creates a NEW variable with
the same name as the outer variable. This prevents the inner loop from
accessing the outer num variable. (This is called "variable
shadowing," where the inner scope variable hides or "shadows" a
variable from an outer scope.)

The lifetime of the inner num ends exactly where the if code block
ends, because that's the scope in which the variable was defined.

This is in contrast to implicitly-declared variables (those without
the var keyword), which use FUNCTION-LEVEL SCOPING (consistent with
Python variable behavior). That means, when you change the value of an
implicitly-declared variable inside the if block, it actually changes
the value for the entire function.

For example, here's the same code but _without_ the var declarations:

def function_scopes():
    num = 1
    if num == 1:
        print(num)   # Reads the function-scope "num"
        num = 2      # Updates the function-scope variable
        print(num)   # Reads the function-scope "num"
    print(num)       # Reads the function-scope "num"

Now, the last print() function sees the updated num value from the
inner scope, because implicitly-declared variables (Python-style
variables) use function-level scope (instead of lexical scope).

COPYING AND MOVING VALUES​

Remember that a variable owns its value, and only one variable can own
a given value at a time. To take this one step further, you can think
of an assignment statement as assigning _ownership_ of a value to a
variable:

owning_variable = "Owned value"

This means the value on the right-hand side of the assignment
statement must be transferrable to the new variable. Here's an example
where that doesn't work:

first = [1, 2, 3]
second = first  # error: 'List[Int]' is not implicitly copyable because it does
                 # not conform to 'ImplicitlyCopyable'

The first assignment is no problem: the expression [1, 2, 3] creates a
new List value that doesn't belong to any variable, so its ownership
can be transferred directly to the first variable.

But the second assignment causes an error. Since the List is owned by
the first variable, it can't simply be transferred to the second
variable without an explicit signal from the user. Does the user want
to transfer the value from first to second? Or create a copy of the
original value?

These choices depend on some features of the type of the values
involved: specifically, if the values are movable, copyable, or
implicitly copyable.

 	*
A _copyable_ type can be copied explicitly, by calling its copy()
method.

second = first.copy()

This leaves first unchanged and assigns second its own, uniquely owned
copy of the list.

 	*
An _implicitly copyable_ type can be copied without an explicit signal
from the user.

one_value = 15
another_value = one_value  # implicit copy

Here one_value is unchanged, and another_value gets a copy of the
value.

Implicitly copyable types are generally simple value types like Int,
Float64, and Bool which can be copied trivially.

 	*
The ownership of a value can be be explicitly transferred from one
variable to another by appending the _transfer sigil_ (^) after the
value to transfer:

second = first^

This moves the value to second, and leaves first uninitialized.

In many cases, this ownership transfer also involves moving the value
from one memory location to another, which requires the value to be
either movable or copyable.

You don't have to digest all of these details now: copyability and
movabiltiy are discussed in more detail in the section on making
structs copyable and movable and in the section on the value
lifecycle.

REFERENCE BINDINGS​

Some APIs return references to values owned elsewhere. References can
be useful to avoid copying values. For example, when you retrieve a
value from a collection, the collection returns a reference, instead
of a copy.

animals: List[String] = ["Cats", "Dogs, "Zebras"]
print(animals[2])  # Prints "Zebras", does not copy the value.

But if you assign a reference to a _variable_, it creates a copy (if
the value is implicitly copyable) or produces an error (if it isn't).

items = [99, 77, 33, 12]
item = items[1]  # item is a copy of items[1]
item += 1  # increments item
print(items[1])  # prints 77

To hold on to a reference, use the ref keyword to create a reference
binding:

ref item_ref = items[1]  # item_ref is a reference to item[1]
item_ref += 1  # increments items[1]
print(items[1])  # prints 78

Here the name item_ref is bound to the reference to items[1]. All
reads and writes to item_ref go to the referenced item.

Reference bindings can also be used when iterating through collections
with for loops.

Once a reference binding is assigned, it can't be re-bound to a
different location. For example:

ref item_ref = items[2]  # error: invalid redefinition of item_ref


TYPES | MODULAR

All values in Mojo have an associated data type. Most of the types are
_nominal_ types, defined by a struct. These types are nominal (or
"named") because type equality is determined by the type's _name_, not
its _structure_.

Mojo comes with a standard library that provides a number of useful
types and utility functions. These standard types aren't privileged.
Each of the standard library types is defined just like user-defined
types—even basic types like Int and String. But these standard
library types are the building blocks you'll use for most Mojo
programs.

The most common types are _built-in types_, which are always available
and don't need to be imported. These include types for numeric values,
strings, boolean values, and others.

The standard library also includes many more types that you can import
as needed, including collection types, utilities for interacting with
the filesystem and getting system information, and so on.

NUMERIC TYPES​

Mojo's most basic numeric type is Int, which represents a signed
integer of the largest size supported by the system—typically 64
bits or 32 bits.

Mojo also has built-in types for integer, unsigned integer, and
floating-point values of various precisions:

Floating Points, Exponents, and Mantissas

eXmX format (like Float8_e5m2 and Float8_e4m3fn in table 3) refers to
the number of bits allocated to a floating point number's exponent and
mantissa.

All IEEE 754 floating point use an implied leading 1. That means
Float32 is e8m23 but effectively e8m24, Float16 is e5m10 but
effectively e5m11, BFloat16 is e8m7 but effectively e8m8, and
Float8_e4m3fn is e4m3 but effectively e4m4.

The types in tables 1, 2, and 3 are actually all aliases to a single
type, SIMD, which is discussed later.

All of the numeric types support the usual numeric and bitwise
operators. The math module provides a number of additional math
functions.

You may wonder when to use Int and when to use the other integer
types. In general, Int is a good safe default when you need an integer
type and you don't require a specific bit width. Using Int as the
default integer type for APIs makes APIs more consistent and
predictable.

AI-OPTIMIZED FLOATING POINT FORMATS​

Several floating point types are specifically designed for AI and
machine learning workloads, trading precision for memory efficiency
and computational throughput.

BFLOAT16 (BRAIN FLOATING POINT) uses the same 8 exponent bits as
Float32, preserving its dynamic range, but uses only 7 bits for the
mantissa (compared to Float32's 23 bits). This makes it ideal for
neural network training where gradient magnitudes vary widely but high
precision is less critical.

8-BIT FORMATS (Float8_e5m2, Float8_e4m3fn, and their fnuz variants)
are ultra-compact formats for AI accelerators where memory bandwidth
is the primary bottleneck. The naming indicates bit allocation: e5m2
means 5 exponent bits and 2 mantissa bits. The fnuz suffix denotes
variants that are finite-only (no infinities) and have unsigned zero
(no -0), used in AMD hardware.

4-BIT FORMAT (Float4_e2m1fn) offers extreme compression with only 2
exponent bits and 1 mantissa bit, used in specialized inference
scenarios where accuracy can be traded for maximum throughput.

SIGNED AND UNSIGNED INTEGERS​

Mojo supports both signed (Int) and unsigned (UInt) integers. You can
use the general Int or UInt types when you do not require a specific
bit width. Note that any alias to a fixed-precision type will be of
type SIMD.

You might prefer to use unsigned integers over signed integers in
conditions where you don't need negative numbers, are not writing for
a public API, or need additional range.

Mojo's UInt type represents an unsigned integer of the word size of
the CPU, which is 64 bits on 64-bit CPUs and 32 bits on 32-bit CPUs.
If you wish to use a fixed size unsigned integer, you can use UInt8,
UInt16, UInt32, or UInt64, which are aliases to the SIMD type.

Signed and unsigned integers of the same bit width can represent the
same number of values, but have different ranges. For example, an Int8
can represent 256 values ranging from -128 to 127. A UInt8 can also
represent 256 values, but represents a range of 0 to 255.

Signed and unsigned integers also have different overflow behavior.
When a signed integer overflows outside the range of values that its
type can represent, the value overflows to negative numbers. For
example, adding 1 to var si: Int8 = 127 results in -128.

When an unsigned integer overflows outside the range of values that
its type can represent, the value overflows to zero. So, adding 1 to
var ui: UInt8 = 255 is equal to 0.

FLOATING-POINT NUMBERS​

Floating-point types represent real numbers. Because not all real
numbers can be expressed in a finite number of bits, floating-point
numbers can't represent every value exactly.

The floating-point types listed in Table 1—Float64, Float32, and
Float16—follow the IEEE 754-2008 standard for representing
floating-point values. Each type includes a sign bit, one set of bits
representing an exponent, and another set representing the fraction or
mantissa. Table 4 shows how each of these types are represented in
memory.

Numbers with exponent values of all ones or all zeros represent
special values, allowing floating-point numbers to represent infinity,
negative infinity, signed zeros, and not-a-number (NaN). For more
details on how numbers are represented, see IEEE 754 on Wikipedia.

A few things to note with floating-point values:

 	*
Rounding errors. Rounding may produce unexpected results. For example,
1/3 can't be represented exactly in these floating-point formats. The
more operations you perform with floating-point numbers, the more the
rounding errors accumulate.

 	*
Space between consecutive numbers. The space between consecutive
numbers is variable across the range of a floating-point number
format. For numbers close to zero, the distance between consecutive
numbers is very small. For large positive and negative numbers, the
space between consecutive numbers is greater than 1, so it may not be
possible to represent consecutive integers.

Because the values are approximate, it is rarely useful to compare
them with the equality operator (==). Consider the following example:

var big_num = 1.0e16
var bigger_num = big_num+1.0
print(big_num == bigger_num)

Comparison operators (< >= and so on) work with floating point
numbers. You can also use the math.isclose() function to compare
whether two floating-point numbers are equal within a specified
tolerance.

NUMERIC LITERALS​

In addition to these numeric types, the standard libraries provides
integer and floating-point literal types, IntLiteral and FloatLiteral.

These literal types are used at compile time to represent literal
numbers that appear in the code. In general, you should never
instantiate these types yourself.

Table 5 summarizes the literal formats you can use to represent
numbers.

At compile time, the literal types are arbitrary-precision (also
called infinite-precision) values, so the compiler can perform
compile-time calculations without overflow or rounding errors.

At runtime the values are converted to finite-precision types—Int
for integer values, and Float64 for floating-point values. (This
process of converting a value that can only exist at compile time into
a runtime value is called _materialization_.)

The following code sample shows the difference between an
arbitrary-precision calculation and the same calculation done using
Float64 values at runtime, which suffers from rounding errors.

var arbitrary_precision = 3.0 * (4.0 / 3.0 - 1.0)
# use a variable to force the following calculation to occur at runtime
var three = 3.0
var finite_precision = three * (4.0 / three - 1.0)
print(arbitrary_precision, finite_precision)

1.0 0.99999999999999978

SIMD AND DTYPE​

To support high-performance numeric processing, Mojo uses the SIMD
type as the basis for its numeric types. SIMD (single instruction,
multiple data) is a processor technology that allows you to perform an
operation on an entire set of operands at once. Mojo's SIMD type
abstracts SIMD operations. A SIMD value represents a SIMD
_vector_—that is, a fixed-size array of values that can fit into a
processor's register. SIMD vectors are defined by two _parameters_:

 	* A DType value, defining the data type in the vector (for example,
32-bit floating-point numbers).
 	* The number of elements in the vector, which must be a power of
two.

For example, you can define a vector of four Float32 values like this:

var vec = SIMD[DType.float32, 4](3.0, 2.0, 2.0, 1.0)

Math operations on SIMD values are applied _elementwise_, on each
individual element in the vector. For example:

var vec1 = SIMD[DType.int8, 4](2, 3, 5, 7)
var vec2 = SIMD[DType.int8, 4](1, 2, 3, 4)
var product = vec1 * vec2
print(product)

[2, 6, 15, 28]

SCALAR VALUES​

The SIMD module defines several comptime values that function as _type
aliases_—shorthand names for different types of SIMD vectors. In
particular, the Scalar type is just a SIMD vector with a single
element. The numeric types listed in Table 1, like Int8 and Float32
are actually type aliases for different types of scalar values:

comptime Scalar = SIMD[size=1]
comptime Int8 = Scalar[DType.int8]
comptime Float32 = Scalar[DType.float32]

This may seem a little confusing at first, but it means that whether
you're working with a single Float32 value or a vector of float32
values, the math operations go through exactly the same code path.

THE DTYPE TYPE​

The DType struct describes the different data types that a SIMD vector
can hold, and defines a number of utility functions for operating on
those data types. The DType struct defines a set of comptime members
that act as identifiers for the different data types, like DType.int8
and DType.float32. You use these comptime members when declaring a
SIMD vector:

var v: SIMD[DType.float64, 16]

Note that DType.float64 isn't a _type_, it's a value that describes a
data type. You can't create a variable with the type DType.float64.
You can create a variable with the type SIMD[DType.float64, 1] (or
Float64, which is the same thing).

from utils.numerics import max_finite, min_finite

def describeDType[dtype: DType]():
    print(dtype, "is floating point:", dtype.is_floating_point())
    print(dtype, "is integral:", dtype.is_integral())
    print("Min/max finite values for", dtype)
    print(min_finite[dtype](), max_finite[dtype]())

describeDType[DType.float32]()

float32 is floating point: True
float32 is integral: False
Min/max finite values for float32
-3.4028234663852886e+38 3.4028234663852886e+38

There are several other data types in the standard library that also
use the DType abstraction.

NUMERIC TYPE CONVERSION​

Constructors and implicit conversion documents the circumstances in
which Mojo automatically converts a value from one type to another.
Importantly, numeric operators DON'T automatically narrow or widen
operands to a common type.

You can explicitly convert a SIMD value to a different SIMD type
either by invoking its cast() method or by passing it as an argument
to the constructor of the target type. For example:

simd1 = SIMD[DType.float32, 4](2.2, 3.3, 4.4, 5.5)
simd2 = SIMD[DType.int16, 4](-1, 2, -3, 4)
simd3 = simd1 * simd2.cast[DType.float32]()  # Convert with cast() method
print("simd3:", simd3)
simd4 = simd2 + SIMD[DType.int16, 4](simd1)  # Convert with SIMD constructor
print("simd4:", simd4)

simd3: [-2.2, 6.6, -13.200001, 22.0]
simd4: [1, 5, 1, 9]

You can convert a Scalar value by passing it as an argument to the
constructor of the target type. For example:

var my_int: Int16 = 12                 # SIMD[DType.int16, 1]
var my_float: Float32 = 0.75           # SIMD[DType.float32, 1]
result = Float32(my_int) * my_float    # Result is SIMD[DType.float32, 1]
print("Result:", result)

Result: 9.0

You can convert a scalar value of any numeric type to Int by passing
the value to the Int() constructor method. Additionally, you can pass
an instance of any struct that implements the Intable trait or
IntableRaising trait to the Int() constructor to convert that instance
to an Int.

You can convert an Int or IntLiteral value to the UInt type by passing
the value to the UInt() constructor. You can't convert other numeric
types to UInt directly, though you can first convert them to Int and
then to UInt.

STRINGS​

Mojo's String type represents a mutable string. (For Python
programmers, note that this is different from Python's standard
string, which is immutable.) Strings support a variety of operators
and common methods.

var s: String = "Testing"
s += " Mojo strings"
print(s)

Testing Mojo strings

Most standard library types conform to the Stringable trait, which
represents a type that can be converted to a string. Use String(value)
to explicitly convert a value to a string:

var s = "Items in list: " + String(5)
print(s)

Items in list: 5

Or use String.write to take variadic Stringable types, so you don't
have to call String() on each value:

var s = String("Items in list: ", 5)
print(s)

Items in list: 5

STRING LITERALS​

As with numeric types, the standard library includes a string literal
type used to represent literal strings in the program source. String
literals are enclosed in either single or double quotes.

Adjacent literals are concatenated together, so you can define a long
string using a series of literals broken up over several lines:

comptime s = "A very long string which is "
        "broken into two literals for legibility."

To define a multi-line string, enclose the literal in three single or
double quotes:

comptime s = """
Multi-line string literals let you
enter long blocks of text, including
newlines."""

Note that the triple double quote form is also used for API
documentation strings.

A StringLiteral will materialize to a String when used at run-time:

comptime param = "foo"        # type = StringLiteral
var runtime_value = "bar"  # type = String
var runtime_value2 = param # type = String

BOOLEANS​

Mojo's Bool type represents a boolean value. It can take one of two
values, True or False. You can negate a boolean value using the not
operator.

var conditionA = False
var conditionB: Bool
conditionB = not conditionA
print(conditionA, conditionB)

False True

Many types have a boolean representation. Any type that implements the
Boolable trait has a boolean representation. As a general principle,
collections evaluate as True if they contain any elements, False if
they are empty; strings evaluate as True if they have a non-zero
length.

Mojo's Tuple type represents an immutable tuple consisting of zero or
more values, separated by commas. Tuples can consist of multiple types
and you can index into tuples in multiple ways.

# Tuples are immutable and can hold multiple types
example_tuple = Tuple[Int, String](1, "Example")

# Assign multiple variables at once
x, y = example_tuple
print(x, y)

# Get individual values with an index
s = example_tuple[1]
print(s)

1 Example
Example

You can also create a tuple without explicit typing.

example_tuple = (1, "Example")
s = example_tuple[1]
print(s)

COLLECTION TYPES​

The Mojo standard library also includes a set of basic collection
types that can be used to build more complex data structures:

 	* List, a dynamically-sized array of items.
 	* Dict, an associative array of key-value pairs.
 	* Set, an unordered collection of unique items.
 	* Optional represents a value that may or may not be present.

The collection types are _generic types_: while a given collection can
only hold a specific type of value (such as Int or Float64), you
specify the type at compile time using a parameter. For example, you
can create a List of Int values like this:

var l: List[Int] = [1, 2, 3, 4]
# l.append(3.14) # error: FloatLiteral cannot be converted to Int

You don't always need to specify the type explicitly. If Mojo can
_infer_ the type, you can omit it. For example, when you construct a
list from a set of integer literals, Mojo creates a List[Int].

# Inferred type == List[Int]
var l1 = [1, 2, 3, 4]

Where you need a more flexible collection, the Variant type can hold
different types of values. For example, a Variant[Int32, Float64] can
hold either an Int32 _or_ a Float64 value at any given time. (Using
Variant is not covered in this section, see the API docs for more
information.)

The following sections give brief introduction to the main collection
types.

LIST​

List is a dynamically-sized array of elements. List elements need to
conform to the Copyable trait. Most of the common standard library
primitives, like Int, String, and SIMD conform to this trait. You can
create a List by passing the element type as a parameter, like this:

var l = List[String]()

The List type supports a subset of the Python list API, including the
ability to append to the list, pop items out of the list, and access
list items using subscript notation.

var list = [2, 3, 5]
list.append(7)
list.append(11)
print("Popping last item from list: ", list.pop())
for idx in range(len(list)):
      print(list[idx], end=", ")

Popping last item from list:  11
2, 3, 5, 7,

Note that the previous code sample leaves out the type parameter when
creating the list. Because the list is being created with a set of Int
values, Mojo can _infer_ the type from the arguments.

 	*
Mojo supports list, set, and dictionary literals for collection
initialization:

# List literal, element type infers to Int.
var nums = [2, 3, 5]

You can also use an explicit type if you want a specific element type:

var list : List[UInt8] = [2, 3, 5]

You can also use list "comprehensions" for compact conditional
initialization:

var list2 = [x*Int(y) for x in nums for y in list if x != 3]

 	*
You can't print() a list, or convert it directly into a string.

# Does not work
print(list)

As shown above, you can print the individual elements in a list as
long as they're a Stringable type.

 	*
Iterating a List returns an immutable reference to each item:

var list = [2, 3, 4]
for item in list:
      print(item, end=", ")

If you would like to mutate the elements of the list, capture the
reference to the element with ref instead of making a copy:

var list = [2, 3, 4]
for ref item in list:     # Capture a ref to the list element
      print(item, end=", ")
      item = 0  # Mutates the element inside the list
print("\nAfter loop:", list[0], list[1], list[2])

2, 3, 4,
After loop: 0 0 0

You can see that the original loop entries were modified.

DICT​

The Dict type is an associative array that holds key-value pairs. You
can create a Dict by specifying the key type and value type as
parameters and using dictionary literals:

# Empty dictionary
var empty_dict: Dict[String, Float64] = {}

# Dictionary with initial key-value pairs
var values: Dict[String, Float64] = {"pi": 3.14159, "e": 2.71828}

You can also use the constructor syntax:

var values = Dict[String, Float64]()

The dictionary's key type must conform to the KeyElement trait, and
value elements must conform to the Copyable trait.

You can insert and remove key-value pairs, update the value assigned
to a key, and iterate through keys, values, or items in the
dictionary.

The Dict iterators all yield references, which are copied into the
declared name by default, but you can use the ref marker to avoid the
copy:

var d: Dict[String, Float64] = {
    "plasticity": 3.1,
    "elasticity": 1.3,
    "electricity": 9.7
}
for item in d.items():
    print(item.key, item.value)

plasticity 3.1000000000000001
elasticity 1.3
electricity 9.6999999999999993

This is an unmeasurable micro-optimization in this case, but is useful
when working with types that aren't Copyable.

SET​

The Set type represents a set of unique values. You can add and remove
elements from the set, test whether a value exists in the set, and
perform set algebra operations, like unions and intersections between
two sets.

Sets are generic and the element type must conform to the KeyElement
trait. Like lists and dictionaries, sets support standard literal
syntax, as well as generator comprehensions:

i_like = {"sushi", "ice cream", "tacos", "pho"}
you_like = {"burgers", "tacos", "salad", "ice cream"}
we_like = i_like.intersection(you_like)

print("We both like:")
for item in we_like:
    print("-", item)

We both like:
- ice cream
- tacos

OPTIONAL​

An Optional represents a value that may or may not be present. Like
the other collection types, it is generic, and can hold any type that
conforms to the Copyable trait.

# Two ways to initialize an Optional with a value
var opt1 = Optional(5)
var opt2: Optional[Int] = 5
# Two ways to initialize an Optional with no value
var opt3 = Optional[Int]()
var opt4: Optional[Int] = None

An Optional evaluates as True when it holds a value, False otherwise.
If the Optional holds a value, you can retrieve a reference to the
value using the value() method. But calling value() on an Optional
with no value results in undefined behavior, so you should always
guard a call to value() inside a conditional that checks whether a
value exists.

var opt: Optional[String] = "Testing"
if opt:
    var value_ref = opt.value()
    print(value_ref)

Alternately, you can use the or_else() method, which returns the
stored value if there is one, or a user-specified default value
otherwise:

var custom_greeting: Optional[String] = None
print(custom_greeting.or_else("Hello"))

custom_greeting = "Hi"
print(custom_greeting.or_else("Hello"))

REGISTER-PASSABLE, MEMORY-ONLY, AND TRIVIAL TYPES​

In various places in the documentation you'll see references to
register-passable, memory-only, and trivial types. Register-passable
and memory-only types are distinguished based on how they hold data:

 	*
Register-passable types are composed exclusively of fixed-size data
types, which can (theoretically) be stored in a machine register. A
register-passable type can include other types, as long as they are
also register-passable. Int, Bool, and SIMD, for example, are all
register-passable types. So a register-passable struct could include
Int and Bool fields, but not a String field. Register-passable types
are declared with the @register_passable decorator.

 	*
Memory-only types consist of all other types that _aren't_
specifically designated as register-passable types. These types often
have pointers or references to dynamically-allocated memory. String,
List, and Dict are all examples of memory-only types.

Register-passable types have a slightly different lifecycle than
memory-only types, which is discussed in Life of a value.

There are also a number of low-level differences in how the Mojo
compiler treats register-passable types versus memory-only types,
which you probably won't have to think about for most Mojo
programming. For more information, see the @register_passable
decorator reference.

Our long-term goal is to make this distinction transparent to the
user, and ensure all APIs work with both register-passable and
memory-only types. But right now you will see a few standard library
types that only work with register-passable types or only work with
memory-only types.

In addition to these two categories, Mojo also has "trivial" types.
Conceptually a trivial type is simply a type that doesn't require any
custom logic in its lifecycle methods. The bits that make up an
instance of a trivial type can be copied or moved without any
knowledge of what they do. Currently, trivial types are declared using
the @register_passable(trivial) decorator. Trivial types shouldn't be
limited to only register-passable types, so in the future we intend to
separate trivial types from the @register_passable decorator.

ANYTYPE AND ANYTRIVIALREGTYPE​

Two other things you'll see in Mojo APIs are references to AnyType and
AnyTrivialRegType. These are effectively _metatypes_, that is, types
of types.

 	* AnyType is a trait that represents a type with a destructor.
You'll find more discussion of it on the Traits page.
 	* AnyTrivialRegType is a metatype representing any Mojo type that's
marked as a trivial type.

You'll see them in signatures like this:

fn any_type_function[ValueType: AnyTrivialRegType](value: ValueType):
    ...

You can read this as any_type_function has an argument, value of type
ValueType, where ValueType is a register-passable type, determined at
compile time.

There is still some code like this in the standard library, but it's
gradually being migrated to more generic code that doesn't distinguish
between register-passable and memory-only types.


OPERATORS, EXPRESSIONS, AND DUNDER METHODS | MODULAR

Mojo includes a variety of operators for manipulating values of
different types. Generally, the operators are equivalent to those
found in Python, though many operators also work with additional Mojo
types such as SIMD vectors. Additionally, Mojo allows you to define
the behavior of most of these operators for your own custom types by
implementing special _dunder_ (double underscore) methods.

OPERATORS AND EXPRESSIONS​

This section lists the operators that Mojo supports, their order or
precedence and associativity, and describes how these operators behave
with several commonly used built-in types.

OPERATOR PRECEDENCE AND ASSOCIATIVITY​

The table below lists the various Mojo operators, along with their
order of precedence and associativity (also referred to as grouping).
This table lists operators from the highest precedence to the lowest
precedence.

		OPERATORS
		DESCRIPTION
		ASSOCIATIVITY (GROUPING)

		()
		Parenthesized expression
		Left to right

		x[index], x[index:index]
		Subscripting, slicing
		Left to right

		**
		Exponentiation
		Right to left

		+x, -x, ~x
		Positive, negative, bitwise NOT
		Right to left

		*, @, /, //, %
		Multiplication, matrix multiplication, division, floor division,
remainder
		Left to right

		+, –
		Addition and subtraction
		Left to right

		<<, >>
		Shifts
		Left to right

		&
		Bitwise AND
		Left to right

		^
		Bitwise XOR
		Left to right

		|
		Bitwise OR
		Left to right

		in, not in, is, is not, <, <=, >, >=, !=, ==
		Comparisons, membership tests, identity tests
		Left to Right

		not x
		Boolean NOT
		Right to left

		x and y
		Boolean AND
		Left to right

		x or y
		Boolean OR
		Left to right

		if-else
		Conditional expression
		Right to left

		:=
		Assignment expression (walrus operator)
		Right to left

Mojo supports the same operators as Python (plus a few extensions),
and they have the same precedence levels. For example, the following
arithmetic expression evaluates to 40:

5 + 4 * 3 ** 2 - 1

It is equivalent to the following parenthesized expression to
explicitly control the order of evaluation:

(5 + (4 * (3 ** 2))) - 1

Associativity defines how operators of the same precedence level are
grouped into expressions. The table indicates whether operators of a
given level are left- or right-associative. For example,
multiplication and division are left associative, so the following
expression results in a value of 3:

3 * 4 / 2 / 2

It is equivalent to the following parenthesized expression to
explicitly control the order of evaluation:

((3 * 4) / 2) / 2

Whereas in the following, exponentiation operators are right
associative resulting in a value of 264,144:

4 ** 3 ** 2

It is equivalent to the following parenthesized expression to
explicitly control the order of evaluation:

4 ** (3 ** 2)

Mojo also uses the caret (^) as the _transfer sigil_. In expressions
where its use might be ambiguous, Mojo treats the character as the
bitwise XOR operator. For example, x^+1 is treated as (x)^(+1).

ARITHMETIC AND BITWISE OPERATORS​

Numeric types describes the different numeric types provided by the
Mojo standard library. The arithmetic and bitwise operators have
slightly different behavior depending on the types of values provided.

INT AND UINT VALUES​

The Int and UInt types represent signed and unsigned integers of the
word size of the CPU, typically 64 bits or 32 bits.

The Int and UInt types support all arithmetic operators except matrix
multiplication (@), as well as all bitwise and shift operators. If
both operands to a binary operator are Int values the result is an
Int, if both operands are UInt values the result is a UInt, and if one
operand is Int and the other UInt the result is an Int. The one
exception for these types is true division, /, which always returns a
Float64 type value.

var a_int: Int = -7
var b_int: Int = 4
sum_int = a_int + b_int  # Result is type Int
print("Int sum:", sum_int)

var i_uint: UInt = 9
var j_uint: UInt = 8
sum_uint = i_uint + j_uint  # Result is type UInt
print("UInt sum:", sum_uint)

sum_mixed = a_int + Int(i_uint)  # Result is type Int
print("Mixed sum:", sum_mixed)

quotient_int = a_int / b_int  # Result is type Float64
print("Int quotient:", quotient_int)
quotient_uint = i_uint / j_uint  # Result is type Float64
print("UInt quotient:", quotient_uint)

Int sum: -3
UInt sum: 17
Mixed sum: 2
Int quotient: -1.75
UInt quotient: 1.125

SIMD VALUES​

The Mojo standard library defines the SIMD type to represent a
fixed-size array of values that can fit into a processor's register.
This allows you to take advantage of single instruction, multiple data
operations in hardware to efficiently process multiple values in
parallel. SIMD values of a numeric DType support all arithmetic
operators except for matrix multiplication (@), though the left shift
(<<) and right shift (>>) operators support only integral types.
Additionally, SIMD values of an integral or boolean type support all
bitwise operators. SIMD values apply the operators in an _elementwise_
fashion, as shown in the following example:

simd1 = SIMD[DType.int32, 4](2, 3, 4, 5)
simd2 = SIMD[DType.int32, 4](-1, 2, -3, 4)
simd3 = simd1 * simd2
print(simd3)

[-2, 6, -12, 20]

Scalar values are simply aliases for single-element SIMD vectors, so
Float16 is just an alias for SIMD[DType.float16, 1]. Therefore Scalar
values support the same set of arithmetic and bitwise operators.

var f1: Float16 = 2.5
var f2: Float16 = -4.0
var f3 = f1 * f2  # Implicitly of type Float16
print(f3)

When using these operators on SIMD values, Mojo requires both to have
the same size and DType, and the result is a SIMD of the same size and
DType. The operators do _not_ automatically widen lower precision SIMD
values to higher precision. This means that the DType of each value
must be the same or else the result is a compilation error.

var i8: Int8 = 8
var f64: Float64 = 64.0
result = i8 * f64

error: invalid call to '__mul__': failed to infer parameter 'type' of parent struct 'SIMD'
    result = i8 * f64
             ~~~^~~~~

If you need to perform an arithmetic or bitwise operator on two SIMD
values of different types, you can explicitly convert a value to the
desired type either by invoking its cast() method or by passing it as
an argument to the constructor of the target type.

For example, to fix the previous example, add an explicit conversion:

var i8: Int8 = 8
var f64: Float64 = 64.0
result = Float64(i8) * f64

Here are some more examples of converting SIMD values using both
constructors and the cast() method:

simd4 = SIMD[DType.float32, 4](2.2, 3.3, 4.4, 5.5)
simd5 = SIMD[DType.int16, 4](-1, 2, -3, 4)
simd6 = simd4 * simd5.cast[DType.float32]()  # Convert with cast() method
print("simd6:", simd6)
simd7 = simd5 + SIMD[DType.int16, 4](simd4)  # Convert with SIMD constructor
print("simd7:", simd7)

simd6: [-2.2, 6.6, -13.200001, 22.0]
simd7: [1, 5, 1, 9]

One exception is that the exponentiation operator, **, is overloaded
so that you can specify an Int type exponent. All values in the SIMD
are exponentiated to the same power.

base_simd = SIMD[DType.float64, 4](1.1, 2.2, 3.3, 4.4)
var power: Int = 2
pow_simd = base_simd ** power  # Result is SIMD[DType.float64, 4]
print(pow_simd)

[1.2100000000000002, 4.8400000000000007, 10.889999999999999, 19.360000000000003]

There are three operators related to division:

 	*
/, the "true division" operator, performs floating point division for
SIMD values with a floating point DType. For SIMD values with an
integral DType, true division _truncates_ the quotient to an integral
result.

num_float16 = SIMD[DType.float16, 4](3.5, -3.5, 3.5, -3.5)
denom_float16 = SIMD[DType.float16, 4](2.5, 2.5, -2.5, -2.5)

num_int32 = SIMD[DType.int32, 4](5, -6, 7, -8)
denom_int32 = SIMD[DType.int32, 4](2, 3, -4, -5)

# Result is SIMD[DType.float16, 4]
true_quotient_float16 = num_float16 / denom_float16
print("True float16 division:", true_quotient_float16)

# Result is SIMD[DType.int32, 4]
true_quotient_int32 = num_int32 / denom_int32
print("True int32 division:", true_quotient_int32)

True float16 division: [1.4003906, -1.4003906, -1.4003906, 1.4003906]
True int32 division: [2, -2, -1, 1]

 	*
//, the "floor division" operator, performs division and _rounds down_
the result to the nearest integer. The resulting SIMD is still the
same type as the original operands. For example:

# Result is SIMD[DType.float16, 4]
var floor_quotient_float16 = num_float16 // denom_float16
print("Floor float16 division:", floor_quotient_float16)

# Result is SIMD[DType.int32, 4]
var floor_quotient_int32 = num_int32 // denom_int32
print("Floor int32 division:", floor_quotient_int32)

Floor float16 division: [1.0, -2.0, -2.0, 1.0]
Floor int32 division: [2, -2, -2, 1]

 	*
%, the modulo operator, returns the remainder after dividing the
numerator by the denominator an integral number of times. The
relationship between the // and % operators can be defined as num ==
denom * (num // denom) + (num % denom). For example:

# Result is SIMD[DType.float16, 4]
var remainder_float16 = num_float16 % denom_float16
print("Modulo float16:", remainder_float16)

# Result is SIMD[DType.int32, 4]
var remainder_int32 = num_int32 % denom_int32
print("Modulo int32:", remainder_int32)

print()

# Result is SIMD[DType.float16, 4]
var result_float16 = denom_float16 * floor_quotient_float16 + remainder_float16
print("Result float16:", result_float16)

# Result is SIMD[DType.int32, 4]
var result_int32 = denom_int32 * floor_quotient_int32 + remainder_int32
print("Result int32:", result_int32)

Modulo float16: [1.0, 1.5, -1.5, -1.0]
Modulo int32: [1, 0, -1, -3]

Result float16: [3.5, -3.5, 3.5, -3.5]
Result int32: [5, -6, 7, -8]

INTLITERAL AND FLOATLITERAL VALUES​

IntLiteral and FloatLiteral are compile-time, numeric values. When
they are used in a compile-time context, they are arbitrary-precision
values. When they are used in a run-time context, they are
materialized as Int and Float64 type values, respectively.

As an example, the following code causes a compile-time error because
the calculated IntLiteral value is too large to store in an Int
variable:

 comptime big_int = (1 << 65) + 123456789  # IntLiteral
var too_big_int: Int = big_int
print("Result:", too_big_int)

note: integer value 36893488147542560021 requires 67 bits to store, but the destination bit width is only 64 bits wide

However in the following example, taking that same IntLiteral value,
dividing by the IntLiteral 10 and then assigning the result to an Int
variable compiles and runs successfully, because the final IntLiteral
quotient can fit in a 64-bit Int.

comptime big_int = (1 << 65) + 123456789  # IntLiteral
var not_too_big_int: Int = big_int // 10
print("Result:", not_too_big_int)

Result: 3689348814754256002

In a compile-time context, IntLiteral and FloatLiteral values support
all arithmetic operators _except_ exponentiation (**), and IntLiteral
values support all bitwise and shift operators. In a run-time context,
materialized IntLiteral values are Int values and therefore support
the same operators as Int, and materialized FloatLiteral values are
Float64 values and therefore support the same operators as Float64.

COMPARISON OPERATORS​

Mojo supports a standard set of comparison operators: ==, !=, <, <=,
>, and >=. However their behavior depends on the type of values being
compared.

The remainder of this section describes numerical comparison
operators. String comparisons are discussed in the String operators.
Several other types in the Mojo standard library support various
comparison operators, in particular the "equal" and "not equal"
comparisons. Consult the API documentation for a type to determine
whether any comparison operators are supported.

BOOL-RETURNING COMPARISONS​

These comparisons return a single Bool value:

 	*
Int, UInt, IntLiteral, and any type that can be implicitly converted
to Int or UInt do standard numerical comparison with a Bool result.

 	*
Equality operators (== and !=) with multi-element SIMD values return a
Bool result using reduction semantics. The comparison is True only if
it's true for all corresponding elements. For example:

simd8 = SIMD[DType.int32, 4](1, 2, 3, 2)
simd9 = SIMD[DType.int32, 4](1, 2, 4, 2)
print("simd8 == simd9:", simd8 == simd9)  # False (element 2 differs)
print("simd8 != simd9:", simd8 != simd9)  # True (not all elements equal)

simd8 == simd9: False
simd8 != simd9: True

 	*
Inequality operators (<, <=, >, >=) with multi-element SIMD values are
not supported. These operators only work with scalar (single-element)
SIMD values.

 	*
Scalar values are simply aliases for single-element SIMD vectors and
support all comparison operators with Bool results:

var float1: Float16 = 12.345         # SIMD[DType.float16, 1]
var float2: Float32 = 0.5            # SIMD[DType.float32, 1]
result = Float32(float1) > float2    # Result is Bool
print(result)

ELEMENTWISE COMPARISONS​

For elementwise comparisons that return a SIMD[DType.bool] result, use
the comparison methods: eq(), ne(), lt(), le(), gt(), and ge(). These
methods work with both SIMD-to-SIMD and SIMD-to-scalar comparisons.
Here are examples showing all six elementwise comparison methods:

simd8 = SIMD[DType.int32, 4](1, 2, 3, 2)
simd9 = SIMD[DType.int32, 4](1, 2, 4, 2)

print("simd8.eq(simd9):", simd8.eq(simd9))    # Equal
print("simd8.ne(simd9):", simd8.ne(simd9))    # Not equal
print("simd8.lt(simd9):", simd8.lt(simd9))    # Less than
print("simd8.le(simd9):", simd8.le(simd9))    # Less than or equal
print("simd8.gt(simd9):", simd8.gt(simd9))    # Greater than
print("simd8.ge(simd9):", simd8.ge(simd9))    # Greater than or equal

simd8.eq(simd9): [True, True, False, True]
simd8.ne(simd9): [False, False, True, False]
simd8.lt(simd9): [False, False, True, False]
simd8.le(simd9): [True, True, True, True]
simd8.gt(simd9): [False, False, False, False]
simd8.ge(simd9): [True, True, False, True]

You can also use these methods for SIMD-to-scalar comparisons:

simd4 = SIMD[DType.int16, 4](-1, 2, -3, 4)
simd5 = simd4.gt(2)  # SIMD[DType.bool, 4]
print("simd4.gt(2):", simd5)

simd6 = SIMD[DType.float32, 4](1.1, -2.2, 3.3, -4.4)
simd7 = simd6.gt(0.5)  # SIMD[DType.bool, 4]
print("simd6.gt(0.5):", simd7)

simd4.gt(2): [False, False, False, True]
simd6.gt(0.5): [True, False, True, False]

Use elementwise comparison methods when you need to compare each
element individually and work with the resulting boolean mask for
further processing.

STRING OPERATORS​

As discussed in Strings, the String type represents a mutable string
value. In contrast, the StringLiteral type represents a literal string
that is embedded into your compiled program, but at run-time it
materializes to a String, allowing you to mutate it:

message = "Hello"       # type = String
comptime name = " Pat"       # type = StringLiteral
greeting = " good Day!"  # type = String

# Mutate the original `message` String
message += name
message += greeting
print(message)

Hello Pat good day!

This means that StringLiteral values can be intermixed with String
values in any runtime expression without having to convert between
types.

STRING CONCATENATION​

The + operator performs string concatenation. The StringLiteral type
supports compile-time string concatenation.

comptime last_name = "Curie"

# Compile-time StringLiteral value
comptime marie = "Marie " + last_name
print(marie)

# Compile-time concatenation before materializing to a run-time `String`
pierre = "Pierre " + last_name
print(pierre)

When concatenating multiple values together to form a String, using
the multi-argument String() constructor is more performant than using
multiple + concatenation operators and can improve code readability.
For example, instead of writing this:

result = "The point at (" + String(x) + ", " + String(y) + ")"

you can write:

result = String("The point at (", x, ", ", y, ")")

This will write the underlying data using a stack buffer, and will
only allocate and memcpy to the heap once.

STRING REPLICATION​

The * operator replicates a String a specified number of times. For
example:

var str1: String = "la"
str2 = str1 * 5
print(str2)

lalalalala

StringLiteral supports the * operator for both compile-time and
run-time string replication. The following examples perform
compile-time string replication resulting in StringLiteral values:

comptime divider1 = "=" * 40
comptime symbol = "#"
comptime divider2 = symbol * 40

# You must define the following function using `fn` because a comptime
# initializer cannot call a function that can potentially raise an error.
fn generate_divider(char: String, repeat: Int) -> String:
    return char * repeat

comptime divider3 = generate_divider("~", 40)  # Evaluated at compile-time

print(divider1)
print(divider2)
print(divider3)

========================================
########################################
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In contrast, the following examples perform run-time string
replication resulting in String values:

repeat = 40
div1 = "^" * repeat
print(div1)
print("_" * repeat)

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
________________________________________

STRING COMPARISON​

String and StringLiteral values can be compared using standard
lexicographical ordering, producing a Bool. For example, "Zebra" is
treated as less than "ant" because upper case letters occur before
lower case letters in the character encoding.

var animal: String = "bird"

is_cat_eq = "cat" == animal
print('Is "cat" equal to "{}"?'.format(animal), is_cat_eq)

is_cat_ne = "cat" != animal
print('Is "cat" not equal to "{}"?'.format(animal), is_cat_ne)

is_bird_eq = "bird" == animal
print('Is "bird" equal to "{}"?'.format(animal), is_bird_eq)

is_cat_gt = "CAT" > animal
print('Is "CAT" greater than "{}"?'.format(animal), is_cat_gt)

is_ge_cat = animal >= "CAT"
print('Is "{}" greater than or equal to "CAT"?'.format(animal), is_ge_cat)

Is "cat" equal to "bird"? False
Is "cat" not equal to "bird"? True
Is "bird" equal to "bird"? True
Is "CAT" greater than "bird"? False
Is "bird" greater than or equal to "CAT"? True

SUBSTRING TESTING​

String, StringLiteral, and StringSlice support using the in operator
to produce a Bool result indicating whether a given substring appears
within another string. The operator is overloaded so that you can use
any combination of String and StringLiteral for both the substring and
the string to test.

var food: String = "peanut butter"

if "nut" in food:
    print("It contains a nut")
else:
    print("It doesn't contain a nut")

It contains a nut

STRING INDEXING AND SLICING​

String, StringLiteral, and StringSlice allow you to use indexing to
return a single character. Character positions are identified with a
zero-based index starting from the first character. You can also
specify a negative index to count backwards from the end of the
string, with the last character identified by index -1. Specifying an
index beyond the bounds of the string results in a run-time error.

var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"  # String type value
print(alphabet[0], alphabet[-1])

# The following would produce a run-time error
# print(alphabet[45])

The String and StringSlice types—but _not_ the StringLiteral
type—also support slices to return a substring from the original
String. Providing a slice in the form [start:end] returns a substring
starting with the character index specified by start and continuing up
to but not including the character at index end. You can use positive
or negative indexing for both the start and end values. Omitting start
is the same as specifying 0, and omitting end is the same as
specifying the length of the string.

var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" # String type value
print(alphabet[1:4])  # The 2nd through 4th characters
print(alphabet[:6])   # The first 6 characters
print(alphabet[-6:])  # The last 6 characters

BCD
ABCDEF
UVWXYZ

You can also specify a slice with a step value, as in [start:end:step]
indicating the increment between subsequent indices of the slide.
(This is also sometimes referred to as a "stride.") If you provide a
negative value for step, characters are selected in reverse order
starting with start but then with _decreasing_ index values up to but
not including end.

print(alphabet[1:6:2])     # The 2nd, 4th, and 6th characters
print(alphabet[-1:-4:-1])  # The last 3 characters in reverse order
print(alphabet[::-1])      # The entire string reversed

BDF
ZYX
ZYXWVUTSRQPONMLKJIHGFEDCBA

IN-PLACE ASSIGNMENT OPERATORS​

Mutable types that support binary arithmetic, bitwise, and shift
operators typically support equivalent in-place assignment operators.
That means that for a type that supports the + operator, the following
two statements are essentially equivalent:

a = a + b
a += b

However there is a subtle difference between the two. In the first
example, the expression a + b produces a new value, which is then
assigned to a. In contrast, the second example does an in-place
modification of the value currently assigned to a. For
register-passable types, the compiled results might be equivalent at
run-time. But for a memory-only type, the first example allocates
storage for the result of a + b and then assigns the value to the
variable, whereas the second example can do an in-place modification
of the existing value.

A type must explicitly implement in-place assignment methods, so you
might encounter some types where in-place equivalents are not
supported.

ASSIGNMENT EXPRESSIONS​

The "walrus" operator, :=, allows you to assign a value to a variable
within an expression. The value provided is both assigned to the
variable and becomes the result of the expression. This often can
simplify conditional or looping logic. For example, consider the
following prompting loop:

while True:
    name = input("Enter a name or 'quit' to exit: ")
    if name == "quit":
        break
    print("Hello,", name)

Enter a name or 'quit' to exit: Coco
Hello, Coco
Enter a name or 'quit' to exit: Vivienne
Hello, Vivienne
Enter a name or 'quit' to exit: quit

Using the walrus operator, you can implement the same behavior like
this:

while (name := input("Enter a name or 'quit' to exit: ")) != "quit":
    print("Hello,", name)

Enter a name or 'quit' to exit: Donna
Hello, Donna
Enter a name or 'quit' to exit: Vera
Hello, Vera
Enter a name or 'quit' to exit: quit

TYPE MERGING​

When an expression involves values of different types, Mojo needs to
statically determine the return type of the expression. This process
is called _type merging_. By default, Mojo determines type merging
based on implicit conversions. Individual structs can also define
custom type merging behavior.

The following code demonstrates type merging based on implicit
conversions:

list = [0.5, 1, 2]
for value in list:
    print(value)

0.5
1.0
2.0

Here, the list literal includes both float and integer literals, which
materialize as Float64 and Int, respectively. Since Int can be
implicitly converted to Float64, the result is a List[Float64].

Here's an example of where type merging fails:

a: Int = 0
b: String = "Hello"
c = a if a > 0 else b   # Error: value of type 'Int' is not compatible with
                        # value of type 'String'mojo

In this case, Int can't be implicitly converted to a String, and
String can't be implicitly converted to an Int, so type merging fails.
This is the correct result: there's no way for Mojo to know what type
you want c to take. You can fix this by adding an explicit conversion:

c = String(a) if a > 0 else b

Individual structs can define custom type merging logic by defining a
__merge_with__() dunder method. For example:

@fieldwise_init
struct MyType(Copyable):
    var val: Int

    def __bool__(self) -> Bool:
        return self.val > 0

    def __merge_with__[other_type: type_of(Int)](self) -> Int:
        return Int(self.val)

def main():
    i = 0
    m = MyType(9)
    print(i if i > 0 else m)  # prints "9"

If either type in the expression defines a custom __merge_with__()
dunder for merging with the other type, this type takes precedence
over any implicit conversions. (Note that the result type doesn't have
to be either of the input types, it could be a third type.)

A type can declare multiple __merge_with__() overrides for different
types.

At a high level, the logic for merging two types goes like this:

	* Does either type define a __merge_with__() method for the other
type? If so, the returned value determines the target type. 

 	* If BOTH types define a __merge_with__() method for the other type,
the two methods must both return the same type, or the conversion
fails.
 	* Both types must be implicitly convertible to the target type (a
type is always implicitly convertible to itself).

	* Is either type implicitly convertible to the other type? 

 	* If only one type is implicitly convertible to the other type,
convert it.
 	* If both types are convertible to the other type, the conversion is
ambiguous, and it fails.

For more background on type merging and the __merge_with__() dunder,
see the proposal, Customizable Type Merging in Mojo.

IMPLEMENT OPERATORS FOR CUSTOM TYPES​

When you create a custom struct, Mojo allows you to define the
behavior of many of the built-in operators for that type by
implementing special _dunder_ (double underscore) methods. This
section lists the dunder methods associated with the operators and
briefly describes the requirements for implementing them.

Currently, Mojo doesn't support defining arbitrary custom operators
(for example, -^-). You can define behaviors for only the operators
listed in the following subsections.

UNARY OPERATOR DUNDER METHODS​

A unary operator invokes an associated dunder method on the value to
which it applies. The supported unary operators and their
corresponding methods are shown in the table below.

		OPERATOR
		DUNDER METHOD

		+ positive
		__pos__()

		- negative
		__neg__()

		~ bitwise NOT
		__invert__()

For each of these methods that you decide to implement, you should
return either the original value if unchanged, or a new value
representing the result of the operator. For example, you could
implement the - negative operator for a MyInt struct like this:

@fieldwise_init
struct MyInt:
    var value: Int

    def __neg__(self) -> Self:
        return Self(-self.value)

BINARY ARITHMETIC, SHIFT, AND BITWISE OPERATOR DUNDER METHODS​

When you have a binary expression like a + b, there are two possible
dunder methods that could be invoked.

Mojo first determines whether the left-hand side value (a in this
example) has a "normal" version of the + operator's dunder method
defined that accepts a value of the right-hand side's type. If so, it
then invokes that method on the left-hand side value and passes the
right-hand side value as an argument.

If Mojo doesn't find a matching "normal" dunder method on the
left-hand side value, it then checks whether the right-hand side value
has a "reflected" (sometimes referred to as "reversed") version of the
+ operator's dunder method defined that accepts a value of the
left-hand side's type. If so, it then invokes that method on the
right-hand side value and passes the left-hand side value as an
argument.

For both the normal and the reflected versions, the dunder method
should return a new value representing the result of the operator.

Additionally, there are dunder methods corresponding to the in-place
assignment versions of the operators. These methods receive the
right-hand side value as an argument and the methods should modify the
existing left-hand side value to reflect the result of the operator.

The table below lists the various binary arithmetic, shift, and
bitwise operators and their corresponding normal, reflected, and
in-place dunder methods.

		OPERATOR
		NORMAL
		REFLECTED
		IN-PLACE

		+ addition
		__add__()
		__radd__()
		__iadd__()

		- subtraction
		__sub__()
		__rsub__()
		__isub__()

		* multiplication
		__mul__()
		__rmul__()
		__imul__()

		/ division
		__truediv__()
		__rtruediv__()
		__itruediv__()

		// floor division
		__floordiv__()
		__rfloordiv__()
		__ifloordiv__()

		% modulus/remainder
		__mod__()
		__rmod__()
		__imod__()

		** exponentiation
		__pow__()
		__rpow__()
		__ipow__()

		@ matrix multiplication
		__matmul__()
		__rmatmul__()
		__imatmul__()

		<< left shift
		__lshift__()
		__rlshift__()
		__ilshift__()

		>> right shift
		__rshift__()
		__rrshift__()
		__irshift__()

		& bitwise AND
		__and__()
		__rand__()
		__iand__()

		| bitwise OR
		__or__()
		__ror__()
		__ior__()

		^ bitwise XOR
		__xor__()
		__rxor__()
		__ixor__()

As an example, consider implementing support for all of the + operator
dunder methods for a custom MyInt struct. This shows supporting adding
two MyInt instances as well as adding a MyInt and an Int. We can
support the case of having the Int as the right-hand side argument by
overloaded the definition of __add__(). But to support the case of
having the Int as the left-hand side argument, we need to implement an
__radd__() method, because the built-in Int type doesn't have an
__add__() method that supports our custom MyInt type.

@fieldwise_init
struct MyInt:
    var value: Int

    def __add__(self, rhs: MyInt) -> Self:
        return MyInt(self.value + rhs.value)

    def __add__(self, rhs: Int) -> Self:
        return MyInt(self.value + rhs)

    def __radd__(self, lhs: Int) -> Self:
        return MyInt(self.value + lhs)

    def __iadd__(mut self, rhs: MyInt) -> None:
        self.value += rhs.value

    def __iadd__(mut self, rhs: Int) -> None:
        self.value += rhs

COMPARISON OPERATOR DUNDER METHODS​

When you have a comparison expression like a < b, Mojo invokes as
associated dunder method on the left-hand side value and passes the
right-hand side value as an argument. Mojo doesn't support "reflected"
versions of these dunder methods because you should only compare
values of the same type. The comparison dunder methods must return a
Bool result representing the result of the comparison.

There are two traits associated with the comparison dunder methods. A
type that implements the Comparable trait defines all of the
comparison methods, and authors are required to implement at least the
"less-than" and "equal" methods, since the trait provides defaults for
the rest. However, some types don't have a natural ordering (for
example, complex numbers). For those types you can decide to implement
the Equatable trait, which defines only the "equal" and "not equal"
comparison methods, with "equal" being required to implement by
conforming structs.

The supported comparison operators and their corresponding methods are
shown in the table below.

		OPERATOR
		DUNDER METHOD

		== equal
		__eq__()

		!= not equal
		__ne__()

		< less than
		__lt__()

		<= less than or equal
		__le__()

		> greater than
		__gt__()

		>= greater than or equal
		__ge__()

The Comparable and Equatable traits don't allow the comparison dunder
methods to raise errors. Because using def to define a method implies
that it can raise an error, you must use fn to implement the
comparison methods declared by these traits. See Functions for more
information on the differences between defining functions with def and
fn.

As an example, consider implementing support for all of the comparison
operator dunder methods for a custom MyInt struct by relying on the
default implementations provided by the Comparable (and transitively
the Equatable) traits.

@fieldwise_init
struct MyInt(Comparable):
    var value: Int

    fn __eq__(self, rhs: MyInt) -> Bool:
        return self.value == rhs.value

    fn __lt__(self, rhs: MyInt) -> Bool:
        return self.value < rhs.value

    # `__ne__`, `__le__`, `__gt__`, and `__ge__` have default implementations.

MEMBERSHIP OPERATOR DUNDER METHODS​

The in and not in operators depend on a type implementing the
__contains__() dunder method. Typically only collection types (such as
List, Dict, and Set) implement this method. It should accept the
right-hand side value as an argument and return a Bool indicating
whether the value is present in the collection or not.

IDENTITY OPERATOR DUNDER METHODS​

The is and is not operators compare the identity of two values.

When a type conforms to Identifiable, these operators call the
__is__() method to determine whether the left-hand operand has the
same identity as the right-hand operand. For example, you might
compare raw values or use some other way to establish what "identity"
means in your work.

The is not operator uses the automatically provided __isnot__()
method, which returns the logical negation of __is__().

SUBSCRIPT AND SLICING DUNDER METHODS​

Subscripting and slicing typically apply only to sequential collection
types, like List and String. Subscripting references a single element
of a collection or a dimension of a multi-dimensional container,
whereas slicing refers to a range of values. A type supports both
subscripting and slicing by implementing the __getitem__() method for
retrieving values and the __setitem__() method for setting values.

SUBSCRIPTING​

In the simple case of a one-dimensional sequence, the __getitem__()
and __setitem__() methods should have signatures similar to this:

struct MySeq[type: Copyable]:
    fn __getitem__(self, idx: Int) -> type:
        # Return element at the given index
        ...
    fn __setitem__(mut self, idx: Int, value: type):
        # Assign the element at the given index the provided value

It's also possible to support multi-dimensional collections, in which
case you can implement both __getitem__() and __setitem__() methods to
accept multiple index arguments—or even variadic index arguments for
arbitrary—dimension collections.

struct MySeq[type: Copyable]:
    # 2-dimension support
    fn __getitem__(self, x_idx: Int, y_idx: Int) -> type:
        ...
    # Arbitrary-dimension support
    fn __getitem__(self, *indices: Int) -> type:
        ...

SLICING​

You provide slicing support for a collection type also by implementing
__getitem__() and __setitem__() methods. But for slicing, instead of
accepting an Int index (or indices, in the case of a multi-dimensional
collection) you implement to methods to accept a Slice (or multiple
Slices in the case of a multi-dimensional collection).

struct MySeq[type: Copyable]:
    # Return a new MySeq with a subset of elements
    fn __getitem__(self, span: Slice) -> Self:
        ...

A Slice contains three fields:

 	* start (Optional[Int]): The starting index of the slice
 	* end (Optional[Int]): The ending index of the slice
 	* step (Optional[Int]): The step increment value of the slice.

Because the start, end, and step values are all optional when using
slice syntax, they are represented as Optional[Int] values in the
Slice. And if present, the index values might be negative representing
a relative position from the end of the sequence. As a convenience,
Slice provides an indices() method that accepts a length value and
returns a 3-tuple of "normalized" start, end, and step values for the
given length, all represented as non-negative values. You can then use
these normalized values to determine the corresponding elements of
your collection being referenced.

struct MySeq[type: Copyable]:
    var size: Int

    # Return a new MySeq with a subset of elements
    fn __getitem__(self, span: Slice) -> Self:
        var start: Int
        var end: Int
        var step: Int
        start, end, step = span.indices(self.size)
        ...

AN EXAMPLE OF IMPLEMENTING OPERATORS FOR A CUSTOM TYPE​

As an example of implementing operators for a custom Mojo type, let's
create a Complex struct to represent a single complex number, with
both the real and imaginary components stored as Float64 values. We'll
implement most of the arithmetic operators, the associated in-place
assignment operators, the equality comparison operators, and a few
additional convenience methods to support operations like printing
complex values. We'll also allow mixing Complex and Float64 values in
arithmetic expressions to produce a Complex result.

This example builds our Complex struct incrementally. You can also
find the complete example in the public GitHub repo.

Note that the Mojo standard library implements a parameterized
ComplexSIMD struct that provides support for a basic set of arithmetic
operators. However, our Complex type will not be based on the
ComplexSIMD struct or be compatible with it.

IMPLEMENT LIFECYCLE METHODS​

Our Complex struct is an example of a simple value type consisting of
trivial numeric fields and requiring no special constructor or
destructor behaviors. This means we can use the
@register_passable("trivial") decorator, which declares that the type
can be trivially copied, moved, and destroyed—and doesn't need a
copy constructor, move constructor, or destructor.

For the time being, we'll also use the @fieldwise_init decorator to
automatically implement a field-wise initializer (a constructor with
arguments for each field).

@fieldwise_init
@register_passable("trivial")
struct Complex:
    var re: Float64
    var im: Float64

This definition is enough for us to create Complex instances and
access their real and imaginary fields.

c1 = Complex(-1.2, 6.5)
print("c1: Real: {}; Imaginary: {}".format(c1.re, c1.im))

c1: Real: -1.2; Imaginary: 6.5

As a convenience, let's add an explicit constructor to handle the case
of creating a Complex instance with an imaginary component of 0.

@register_passable("trivial")
struct Complex():
    var re: Float64
    var im: Float64

    fn __init__(out self, re: Float64, im: Float64 = 0.0):
        self.re = re
        self.im = im

Since this constructor also handles creating a Complex instance with
both real and imaginary components, we don't need the @fieldwise_init
decorator anymore.

Now we can create a Complex instance and provide just a real
component.

c2 = Complex(3.14159)
print("c2: Real: {}; Imaginary: {}".format(c2.re, c2.im))

c2: Real: 3.1415899999999999; Imaginary: 0.0

IMPLEMENT THE WRITABLE AND STRINGABLE TRAITS​

To make it simpler to print Complex values, let's implement the
Writable trait. While we're at it, let's also implement the Stringable
trait so that we can use the String() constructor to generate a String
representation of a Complex value. You can find out more about these
traits and their associated methods in The Stringable, Representable,
and Writable traits.

@register_passable("trivial")
struct Complex(
    Writable,
    Stringable,
):
    # ...

    fn __str__(self) -> String:
        return String.write(self)

    fn write_to(self, mut writer: Some[Writer]):
        writer.write("(", self.re)
        if self.im < 0:
            writer.write(" - ", -self.im)
        else:
            writer.write(" + ", self.im)
        writer.write("i)")

The Writable trait doesn't allow the write_to() method to raise an
error and the Stringable trait doesn't allow the __str__() method to
raise an error. Because defining a method with def implies that it can
raise an error, we instead have to define these methods with fn. See
Functions for more information on the differences between defining
functions with def and fn.

Now we can print a Complex value directly, and we can explicitly
generate a String representation by passing a Complex value to
String() which constructs a new String from all the arguments passed
to it.

c3 = Complex(3.14159, -2.71828)
print("c3 =", c3)

var msg = String("The value is: ", c3)
print(msg)

c3 = (3.1415899999999999 - 2.71828i)
The value is: (3.1415899999999999 - 2.71828i)

IMPLEMENT BASIC INDEXING​

Indexing usually is supported only by collection types. But as an
example, let's implement support for accessing the real component as
index 0 and the imaginary component as index 1. We'll not implement
slicing or variadic assignment for this example.

    # ...
    def __getitem__(self, idx: Int) -> Float64:
        if idx == 0:
            return self.re
        elif idx == 1:
            return self.im
        else:
            raise "index out of bounds"

    def __setitem__(mut self, idx: Int, value: Float64) -> None:
        if idx == 0:
            self.re = value
        elif idx == 1:
            self.im = value
        else:
            raise "index out of bounds"

Now let's try getting and setting the real and imaginary components of
a Complex value using indexing.

c2 = Complex(3.14159)
print("c2[0]: {}; c2[1]: {}".format(c2[0], c2[1]))
c2[0] = 2.71828
c2[1] = 42
print("c2[0] = 2.71828; c2[1] = 42; c2:", c2)

c2[0]: 3.1415899999999999; c2[1]: 0.0
c2[0] = 2.71828; c2[1] = 42; c2: (2.71828 + 42.0i)

IMPLEMENT ARITHMETIC OPERATORS​

Now let's implement the dunder methods that allow us to perform
arithmetic operations on Complex values. (Refer to the Wikipedia page
on complex numbers for a more in-depth explanation of the formulas for
these operators.)

IMPLEMENT BASIC OPERATORS FOR COMPLEX VALUES​

The unary + operator simply returns the original value, whereas the
unary - operator returns a new Complex value with the real and
imaginary components negated.

    # ...
    def __pos__(self) -> Self:
        return self

    def __neg__(self) -> Self:
        return Self(-self.re, -self.im)

Let's test these out by printing the result of applying each operator.

c1 = Complex(-1.2, 6.5)
print("+c1:", +c1)
print("-c1:", -c1)

+c1: (-1.2 + 6.5i)
-c1: (1.2 - 6.5i)

Next we'll implement the basic binary operators: +, -, *, and /.
Dividing complex numbers is a bit tricky, so we'll also define a
helper method called norm() to calculate the Euclidean norm of a
Complex instance, which can also be useful for other types of analysis
with complex numbers.

For all of these dunder methods, the left-hand side operand is self
and the right-hand side operand is passed as an argument. We return a
new Complex value representing the result.

from math import sqrt

# ...

    def __add__(self, rhs: Self) -> Self:
        return Self(self.re + rhs.re, self.im + rhs.im)

    def __sub__(self, rhs: Self) -> Self:
        return Self(self.re - rhs.re, self.im - rhs.im)

    def __mul__(self, rhs: Self) -> Self:
        return Self(
            self.re * rhs.re - self.im * rhs.im,
            self.re * rhs.im + self.im * rhs.re
        )

    def __truediv__(self, rhs: Self) -> Self:
        denom = rhs.squared_norm()
        return Self(
            (self.re * rhs.re + self.im * rhs.im) / denom,
            (self.im * rhs.re - self.re * rhs.im) / denom
        )

    def squared_norm(self) -> Float64:
        return self.re * self.re + self.im * self.im

    def norm(self) -> Float64:
        return sqrt(self.squared_norm())

Now we can try them out.

c1 = Complex(-1.2, 6.5)
c3 = Complex(3.14159, -2.71828)
print("c1 + c3 =", c1 + c3)
print("c1 - c3 =", c1 - c3)
print("c1 * c3 =", c1 * c3)
print("c1 / c3 =", c1 / c3)

c1 + c3 = (1.9415899999999999 + 3.78172i)
c1 - c3 = (-4.3415900000000001 + 9.21828i)
c1 * c3 = (13.898912000000001 + 23.682270999999997i)
c1 / c3 = (-1.2422030701265261 + 0.99419218883955773i)

IMPLEMENT OVERLOADED ARITHMETIC OPERATORS FOR FLOAT64 VALUES​

Our initial set of binary arithmetic operators work fine if both
operands are Complex instances. But if we have a Float64 value
representing just a real value, we'd first need to use it to create a
Complex value before we could add, subtract, multiply, or divide it
with another Complex value. If we think that this will be a common use
case, it makes sense to overload our arithmetic methods to accept a
Float64 as the second operand.

For the case where we have complex1 + float1, we can just create an
overloaded definition of __add__(). But what about the case of float1
+ complex1? By default, when Mojo encounters a + operator it tries to
invoke the __add__() method of the left-hand operand, but the built-in
Float64 type doesn't implement support for addition with a Complex
value. This is an example where we need to implement the __radd__()
method on the Complex type. When Mojo can't find an __add__(self, rhs:
Complex) -> Complex method defined on Float64, it uses the
__radd__(self, lhs: Float64) -> Complex method defined on Complex.

So we can support arithmetic operations on Complex and Float64 values
by implementing the following eight methods.

    # ...
    def __add__(self, rhs: Float64) -> Self:
        return Self(self.re + rhs, self.im)

    def __radd__(self, lhs: Float64) -> Self:
        return Self(self.re + lhs, self.im)

    def __sub__(self, rhs: Float64) -> Self:
        return Self(self.re - rhs, self.im)

    def __rsub__(self, lhs: Float64) -> Self:
        return Self(lhs - self.re, -self.im)

    def __mul__(self, rhs: Float64) -> Self:
        return Self(self.re * rhs, self.im * rhs)

    def __rmul__(self, lhs: Float64) -> Self:
        return Self(lhs * self.re, lhs * self.im)

    def __truediv__(self, rhs: Float64) -> Self:
        return Self(self.re / rhs, self.im / rhs)

    def __rtruediv__(self, lhs: Float64) -> Self:
        denom = self.squared_norm()
        return Self(
            (lhs * self.re) / denom,
            (-lhs * self.im) / denom
        )

Let's see them in action.

c1 = Complex(-1.2, 6.5)
f1 = 2.5
print("c1 + f1 =", c1 + f1)
print("f1 + c1 =", f1 + c1)
print("c1 - f1 =", c1 - f1)
print("f1 - c1 =", f1 - c1)
print("c1 * f1 =", c1 * f1)
print("f1 * c1 =", f1 * c1)
print("c1 / f1 =", c1 / f1)
print("f1 / c1 =", f1 / c1)

c1 + f1 = (1.3 + 6.5i)
f1 + c1 = (1.3 + 6.5i)
c1 - f1 = (-3.7000000000000002 + 6.5i)
f1 - c1 = (3.7000000000000002 - 6.5i)
c1 * f1 = (-3.0 + 16.25i)
f1 * c1 = (-3.0 + 16.25i)
c1 / f1 = (-0.47999999999999998 + 2.6000000000000001i)
f1 / c1 = (-0.068665598535133904 - 0.37193865873197529i)

IMPLEMENT IN-PLACE ASSIGNMENT OPERATORS​

Now let's implement support for the in-place assignment operators: +=,
-=, *=, and /=. These modify the original value, so we need to mark
self as being an mut argument and update the re and im fields instead
of returning a new Complex instance. And once again, we'll overload
the definitions to support both a Complex and a Float64 operand.

    # ...
    def __iadd__(mut self, rhs: Self) -> None:
        self.re += rhs.re
        self.im += rhs.im

    def __iadd__(mut self, rhs: Float64) -> None:
        self.re += rhs

    def __isub__(mut self, rhs: Self) -> None:
        self.re -= rhs.re
        self.im -= rhs.im

    def __isub__(mut self, rhs: Float64) -> None:
        self.re -= rhs

    def __imul__(mut self, rhs: Self) -> None:
        new_re = self.re * rhs.re - self.im * rhs.im
        new_im = self.re * rhs.im + self.im * rhs.re
        self.re = new_re
        self.im = new_im

    def __imul__(mut self, rhs: Float64) -> None:
        self.re *= rhs
        self.im *= rhs

    def __itruediv__(mut self, rhs: Self) -> None:
        denom = rhs.squared_norm()
        new_re = (self.re * rhs.re + self.im * rhs.im) / denom
        new_im = (self.im * rhs.re - self.re * rhs.im) / denom
        self.re = new_re
        self.im = new_im

    def __itruediv__(mut self, rhs: Float64) -> None:
        self.re /= rhs
        self.im /= rhs

And now to try them out.

c4 = Complex(-1, -1)
print("c4 =", c4)
c4 += Complex(0.5, -0.5)
print("c4 += Complex(0.5, -0.5) =>", c4)
c4 += 2.75
print("c4 += 2.75 =>", c4)
c4 -= Complex(0.25, 1.5)
print("c4 -= Complex(0.25, 1.5) =>", c4)
c4 -= 3
print("c4 -= 3 =>", c4)
c4 *= Complex(-3.0, 2.0)
print("c4 *= Complex(-3.0, 2.0) =>", c4)
c4 *= 0.75
print("c4 *= 0.75 =>", c4)
c4 /= Complex(1.25, 2.0)
print("c4 /= Complex(1.25, 2.0) =>", c4)
c4 /= 2.0
print("c4 /= 2.0 =>", c4)

c4 = (-1.0 - 1.0i)
c4 += Complex(0.5, -0.5) => (-0.5 - 1.5i)
c4 += 2.75 => (2.25 - 1.5i)
c4 -= Complex(0.25, 1.5) => (2.0 - 3.0i)
c4 -= 3 => (-1.0 - 3.0i)
c4 *= Complex(-3.0, 2.0) => (9.0 + 7.0i)
c4 *= 0.75 => (6.75 + 5.25i)
c4 /= Complex(1.25, 2.0) => (3.404494382022472 - 1.247191011235955i)
c4 /= 2.0 => (1.702247191011236 - 0.6235955056179775i)

IMPLEMENT EQUALITY OPERATORS​

The field of complex numbers is not an ordered field, so it doesn't
make sense for us to implement the Comparable trait and the >, >=, <,
and <= operators. However, we can implement the Equatable trait and
the == and != operators. (Of course, this suffers the same limitation
of comparing floating point numbers for equality because of the
limited precision of representing floating point numbers when
performing arithmetic operations. But we'll go ahead and implement the
operators for completeness.)

struct Complex(
    Equatable,
    Formattable,
    Stringable,
):
    # ...
    fn __eq__(self, other: Self) -> Bool:
        return self.re == other.re and self.im == other.im

    fn __ne__(self, other: Self) -> Bool:
        return self.re != other.re or self.im != other.im

The Equatable trait doesn't allow the __eq__() and __ne__() methods to
raise errors. Because defining a method with def implies that it can
raise an error, we instead have to define these methods with fn. See
Functions for more information on the differences between defining
functions with def and fn.

And now to try them out.

c1 = Complex(-1.2, 6.5)
c3 = Complex(3.14159, -2.71828)
c5 = Complex(-1.2, 6.5)

if c1 == c5:
    print("c1 is equal to c5")
else:
    print("c1 is not equal to c5")

if c1 != c3:
    print("c1 is not equal to c3")
else:
    print("c1 is equal to c3")

c1 is equal to c5
c1 is not equal to c3
