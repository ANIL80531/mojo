def main():
    print("Hello, world!")
    x = 10
    y = x * x
    print(y)
    var xx: Int = 10 #explicitly declared variables
    var sum: Int = xx + xx
    print(sum)
    z = 10
    # z = "foo" wrong type of first value assigned, type change is not allowed
    print(z)

    def loop():
        for x in range(5):
            if x % 2 == 0:
                print(x)

    loop()

    def print_line():
        long_text = "This is a long line of text that is a lot easier to read if"
                    " it is broken up across two lines instead of one long line."
        print(long_text)
    
    print_line()

    fn greet(name: String) -> String:
        return "Hello, " + name + "!"

    a = greet(name = "Nityansh")
    print(a)

    # Mojo structs are completely static—they are bound at compile-time,
    # so they do not allow dynamic dispatch or any runtime changes to the structure.
    # Structs are blueprint (like a word doc template)
    # struct keep related data neatly bundled together
    # I don't understand struct & traits find good material.
    # Traits implements generic functions(single implementation with methods over multiple
    # input data types) for structs.
    
#    """
#    trait SomeTrait:
#    fn required_method(self, x: Int): ...
#    # 3 dots mean method is not implemented.
#    """

    # In Mojo, a parameter is a compile-time variable that becomes a runtime constant, and
        # it's declared in square brackets on a function or struct.
        # Parameters allow for compile-time metaprogramming, which means you can generate or
        # modify code at compile time.

    # when we say things like "parameter" and "parametric function,"
    # we're talking about these compile-time parameters.
    # Whereas, a function "argument" is a runtime value that's declared in parentheses.
    
def repeat[count: Int](msg: String):
    @parameter # evaluate the following for loop at compile time
    for i in range(count):
        print(msg)

#    repeat[3]("Hi...")
