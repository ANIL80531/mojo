def main():
    # A variable is a name that holds a value or object.
    # All variables in Mojo are mutable—their value can be changed.
    var greeting: String = "Hello World!"
    # Explicite variables (clearly stated in detail) declared with var keyword.
    # Explicitly-declared variables follow lexical scoping, unlike implicitly-declared variables.
    # This means that nested code blocks can read and modify variables defined in an outer scope.
    # But an outer scope cannot read variables defined in an inner scope at all.
    # Late initialization works only if the variable is declared with a type.
    var a = 5
    var b: Float64 = 3.14
    var c: String = "Anil"
    var secondName = String("Beniwal")
    print(secondName)
    # Implicite variables (not expressed) are declared without var or let keyword.
    # Implicitly-declared variables are strongly typed:
    # They take the type from the first value assigned to them.
    # Implicitly-declared variables are scoped at the function level.
    d = 5
    f: Float64 = 2.781
    # Once created variable it's type never changes.
    # You can not assign a variable a value of different type.
    var temp: Float64 = 99
    var temp2: Float64 = Float64(99)
    print(temp, temp2, a, b, c, d, f, greeting)
    # Int 99 converted to float64 = type casting
    # Value assignment can be converted into a constructor call by
    # Decorating with the @implicit decorator.
    # It takes a single required argument that matches the value being assigned.
    # Implicit conversion follows the logic of overloaded functions.
    # If the destination type has a viable implicit conversion constructor for the source type,
    # It can be invoked for implicit conversion.

    # Note that the var statement inside the if creates a new variable with the same name as the outer variable.
    # This prevents the inner loop from accessing the outer num variable.
    # This is called "variable shadowing," where the inner scope variable hides or "shadows" a variable from an outer scope.
    var no_shadow = 0
    if no_shadow == 0:
        no_shadow = 1     # implicite fuction level scoping
        print(no_shadow)
        var no_shadow = 2 # Shadowing outer variable
        print(no_shadow)
    print(no_shadow)
    first = [1,2,3]
    second = first  # copy or transfer dilemma
    print(second.__str__()) # How does this worked
    animals: List[String] = ["Cats", "Dogs", "Zebras"]
    print(animals[2])  # Prints "Zebras", does not copy the value.



