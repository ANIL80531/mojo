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
