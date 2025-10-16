def main():
    print(add(b = 5,a = 7))
    sq(3)
    sq()
    kwarg(a = 1, b = 3.1, c = "Hi", d = True)
    Regpass_vargs(1,2,3)
    MemPass_vargs("Hello","World","!")
    print(len("Hi"))
    print(count_many_things(5, 11.7, 12))
    print_nicely(m=7.2, n=8.1)
    print(min(5, 2))
    print(kw_only_args(10,10))
    print(add2("Hello,"," world!"))
    print(add2(1,2))

#if __name__ == "__main__":
#    main()

# def and fn

# def function_name[
#     compile time parameters used for metaprogramming...
# ](
#     run time arguments ...
# ) -> return_value_type:
#     function_body is  executed when a funcion is called.

def do_nothing():
    pass

def add(a: Int, b: Int) -> Int:
    print("\n\n\n\n")
    print(a)
    print(b)
    return a+b

# parameter as a compile-time variable
# that becomes a run-time constant.
# The compiler doesn't allow a function declared with fn to raise an error condition
# unless it explicitly includes a raises declaration.
# In contrast, the compiler assumes that all functions declared with def might raise an error.
# You might see the following characters in place of arguments: slash (/) and/or star (*).
# Arguments before the / can be passed only by position. Arguments after the * can be passed only by keyword.

def sq(x: Int = 5): # Optional argument
    print(x**2)

    # Any optional arguments must appear after any required arguments.

def kwarg(a: Int8, b: Float32, c: String, d: Bool) -> None: # keyword arguments
    print(a,b,c,d)

def Regpass_vargs(*variadicargs: Int) -> None: # Variadic arguments let a function accept a variable number of arguments.
    for i in variadicargs:
        print(i)

# You can define zero or more arguments before the variadic argument.
# When calling the function, any remaining positional arguments are assigned to the
# variadic argument, so any arguments declared after the variadic argument
# can only be specified by keyword.
# Variadic arguments can be divided into two categories:
    # Homogeneous: all of the passed arguments are the same type — all Int, or all String.
    # Heterogeneous: different argument types.

def MemPass_vargs(*x: String):
    for i in x:
        print(i)

fn count_many_things[*ArgTypes: Intable](*args: *ArgTypes) -> Int:
    var total = 0

    @parameter
    for i in range(args.__len__()):
        total += Int(args[i])

    return total

# Variadic keyword arguments allow the user to pass an arbitrary number of keyword arguments.
fn print_nicely(**kwargs: Float64) raises:
  for i in kwargs.keys():
      print(i, "=", kwargs[i])

# In this example, the argument name kwargs is a placeholder that accepts any number of 
# keyword arguments. Inside the body of the function, you can access the arguments as a 
# dictionary of keywords and argument values.
# Any arguments before the / are positional-only: they can't be passed as keyword arguments
fn min(a: Int, b: Int, /) -> Int:
    return a if a < b else b

# There are several reasons you might want to write a function with positional-only arguments:
    # The argument names aren't meaningful for the caller.
    # You want the freedom to change the argument names later on without breaking backward compatibility.

# Keyword-only arguments are the inverse of positional-only arguments:
#     they can be specified only by keyword. If a function accepts variadic arguments,
#     any arguments defined after the variadic arguments are treated as keyword-only.
#     If the function doesn't accept variadic arguments, you can add a single star (*)
#     to the argument list to separate the keyword-only arguments.

# Keyword-only arguments often have default values, but this is not required.
# If a keyword-only argument doesn't have a default value, it is a required keyword-only argument.
# It must be specified, and it must be specified by keyword.


fn kw_only_args(a1: Int, a2: Int, *, double: Bool = True) -> Int:
	var product = a1 * a2
	if double:
		return product * 2
	else:
		return product

# Any required keyword-only arguments must appear in the signature
# before any optional keyword-only arguments.
# That is, arguments appear in the following sequence a function signature:

    # Required positional arguments.
    # Optional positional arguments.
    # Variadic arguments.
    # Required keyword-only arguments.
    # Optional keyword-only arguments.
    # Variadic keyword arguments.

# Overloaded functions ~ Multiple Dispatch
    # All function declarations must specify argument types, so if you want a want
    # a function to work with different data types, you need to implement separate
    # versions of the function that each specify different argument types. This is
    # called "overloading" a function.
# Overloading also works with combinations of both fn and def function declarations.


fn add2(x: Int, y: Int) -> Int:
    return x + y

fn add2(x: String, y: String) -> String:
    return x + y

# Return values
# Return value types are declared in the signature using the -> type syntax.
# Values are passed using the return keyword, which ends the function and
# returns the identified value (if any) to the caller.
# By default, the value is returned to the caller as an owned value.
# A function can also return a mutable or immutable reference using a ref return value.
# Named results
    # Named function results allow a function to return a value that can't be moved or copied.
    # Named result syntax lets you specify a named,
    # uninitialized variable to return to the caller using the out argument convention.
    # A function can declare only one return value, 
    # whether it's declared using an out argument or using the standard -> type syntax.
    # A function with a named result argument doesn't need to include an explicit return statement.
    # If the function terminates without a return, or at a return statement with no value,
    # the value of the out argument is returned to the caller.
    # If it includes a return statement with a value, that value is returned to the caller, as usual.
    # Because the return value is assigned to this special out variable,
    # it doesn't need to be moved or copied when it's returned to the caller.

# Raising and non-raising functions
    # By default, when a function raises an error, the function terminates immediately and
    # the error propagates to the calling function.
    # If the calling function doesn't handle the error, it continues to propagate up the call stack.
    # The Mojo compiler always treats a function declared with def as a raising function,
    # even if the body of the function doesn't contain any code that could raise an error.
    # Functions declared with fn without the raises keyword are non-raising functions—that is,
    # they are not allowed to propagate an error to the calling function.
    # If a non-raising function calls a raising function, it must handle any possible errors.


