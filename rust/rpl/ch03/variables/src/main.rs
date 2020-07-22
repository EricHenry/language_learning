const MAX_POINTS: u32 = 100_000;

fn main() {
    let mut x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);

    main_();
}

fn main_() {
    let x = 5;
    let x = x + 1;
    let x = x * 2;

    println!("the value of x is: {}", x);
}
