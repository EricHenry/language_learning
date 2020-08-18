fn main() {
    // s is not valid  here; its not yet declared
    let s = "hello"; // s is valid from this point forward "hello" is a string literal
                     // do stuff with s
} // this scope is now over, and s is no longer valid

fn string_example() {
    let s = String::from("hello");
    s.push_str(", world!"); // push_str() appends a literal to a String
    println!("{}", s); // this will print `hello, world!`
}

fn string_scope_example() {
    let s = String::from("hello"); // s is valid from this point forward
                                   // do stuff with s
} // this scope is now over, and s is no longer valid

//------------------------------------------
// Ex: 4.3
//------------------------------------------

fn string_ownership_example() {
    let s = String::from("hello"); // s comes into scope

    takes_ownership(s); // s's value moves into the function
                        // and is is no longer valid here
    let x = 5; // x comes into scope

    makes_copy(x); // x would move into the function,
                   // but i32 is Copy, so it's okay to
                   // still use x afterward
} // Here, x goes out of scope, and then s. But because s's value was moved,
  // nothing special happens

fn takes_ownership(some_string: String) {
    // some_string comes into scope
    println!("{}", some_string);
} // here, some_stirng goes out of scope and `drop` is called. the backing
  // memory is freed.

fn makes_copy(some_integer: i32) {
    // some_integer comes into scope
    println!("{}", some_integer);
} // Here, some_intger goes out of scope. Nothing special happens.

//------------------------------------------
// Ex: 4.4
//------------------------------------------

fn give_ownership_example() {
    let s1 = gives_ownership(); // gives_ownership moves its return
                                // value into s1
    let s2 = String::from("hello"); // s2 comes into scope

    let s3 = takes_and_gives_back(s2); //s2 is moved into
                                       // takes_and_gives_back, which also
                                       // moves its return value into s3
} // Here, s3 goes out of scope and is dropped. s2 goes out of scope but was
  // moved, so nothing happens. s1 goes out of scope and is dropped.

fn gives_ownership() -> String {
    // gives_ownership will move its
    // return value into the function
    // that calls it
    let some_string = String::from("hello"); // some_string comes into scope some_string
                                             // some_string is returned and
                                             // moves out to the calling function
    some_string
}

// takes_and_gives_back will take a String and return a one
fn takes_and_gives_back(a_string: String) -> String {
    // a_string comes into scope
    a_string // a_string is returned and moves out to the calling function
}

//------------------------------------------
// Ex: 4.5
//------------------------------------------

fn reference_and_borrow_example() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    // s is a reference to a String
    s.len()
} // Here, s igoes out of scope. But because it does not have ownership of
  // what it refers to, nothin happens.

//------------------------------------------
// Ex: 4.6
//------------------------------------------

fn borrowing_example() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}

fn multiple_mut_refs_example() {
    let mut s = String::from("hello");

    {
        let r1 = &mut s;
    } // r1 goes out of scope here, so we can make a new reference with no problems.

    let r2 = &mut s;
}

//------------------------------------------
// Ex: 4.8
//------------------------------------------

fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}
