## Madhuri Komuravelly
## Surekha Kotiyala
## Ramakrishna Veeravalli

# Question 1
```
class Person {
   var firstName: String?
   var lastName: String?
   let gender = "female"
	}
   let john = Person()
 	john.firstName = "John"
john.lastName = "Doe"
john.gender = "male"

Does the above code work? if works, what is the output, if not why?
```
# Question 2  
```
//case1
struct S { var data: Int = -1 }
var a = S() 
var b = a						
 a.data = 42						
println("\(a.data), \(b.data)")
	
//case 2
class C { var data: Int = -1 } 
var x = C() 
var y = x						
x.data = 42					
println("\(x.data), \(y.data)")	

what will be the output in both cases and explain why?
```


# Question 3 
```
Provide an operator for comparing reference-type constants and variables to determine whether they refer to same object?
```
