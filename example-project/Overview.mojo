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
    # Code blocks such as functions, conditions, and loops are defined with a colon followed by indented lines (4 spaces).
    def loop():
        for x in range(5):
            if x % 2 == 0:
                print(x)
                # All statements end with a blank line.

    loop()

    #def print_hello():
    #    text = "Hello,".join(" world!")
    #    print(text)
    
    #print_hello()
    

    def print_line():
        long_text = "This is a long line of text that is a lot easier to read if"
                    " it is broken up across two lines instead of one long line."
        print(long_text)
    
    print_line()




    fn greet(name: String) -> String:
        return "Hello, " + name + "!"

    a = greet(name = "world")
    print(a)

    # Mojo structs are completely static—they are bound at compile-time, so they do not allow dynamic dispatch or any runtime changes to the structure.
    # Structs are blueprint (like a word doc template)
        # struct keep related data neatly bundled together
    # I don't understand struct & traits find good material.

trait SomeTrait:
    fn required_method(self, x: Int): ...
    # 3 dots mean method is not implemented.
