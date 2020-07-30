use std::fs::File;
use std::io::{self, Write};
use std::sync::{mpsc, Arc, Mutex};
use std::time::Duration;
use std::vec::Vec;

extern crate clap;
use clap::{App, Arg};

#[derive(Clone, Debug)]
struct Problem {
    question: String,
    answer: String,
}

#[derive(Clone, Debug)]
struct Answer {
    expected: String,
    actual: String,
}

enum GameState {
    Complete,
}

fn main() -> std::io::Result<()> {
    let matches = App::new("Quiz Game!")
        .version("0.1")
        .author("EH")
        .about("a little quiz game")
        .arg(
            Arg::with_name("location")
                .short("l")
                .long("location")
                .value_name("FILE")
                .help("The location of the problems to use")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("time")
                .short("t")
                .long("time")
                .value_name("SECONDS")
                .help("How long the game will last")
                .takes_value(true),
        )
        .get_matches();

    let location = matches
        .value_of("location")
        .unwrap_or("problems/problems.csv");
    let game_time: u64 = matches
        .value_of("time")
        .unwrap_or("30")
        .parse()
        .expect("game time should be a number");

    // open file
    let file = File::open(location)?;
    // Build the CSV reader and iterate over each record.
    let mut rdr = csv::Reader::from_reader(file);
    // transform the csv records into problems.
    let problems: Vec<Problem> = rdr
        .records()
        .filter_map(|r| match r {
            Ok(record) => Some(record),
            _ => None,
        })
        .filter_map(|x| match (x.get(0), x.get(1)) {
            (Some(question), Some(answer)) => Some(Problem {
                question: question.to_string(),
                answer: answer.to_string(),
            }),
            _ => None,
        })
        .collect();
    let num_problems = problems.len();

    println!("Welcome to the Quiz Game!");
    println!(
        "You will have {} seconds to complete as many questions as you can",
        game_time
    );

    loop {
        println!("Are you ready to start the game? (y/n)");

        let mut resp = String::new();
        io::stdin()
            .read_line(&mut resp)
            .expect("Failed to read guess");

        if resp.trim() == "y" {
            break;
        }
    }

    // create a channel for communication of game state
    let (state_tx, state_rx) = mpsc::channel();
    let answers: Arc<Mutex<Vec<Answer>>> = Arc::new(Mutex::new(Vec::new()));
    let ans = Arc::clone(&answers);
    std::thread::spawn(move || {
        for p in problems.iter() {
            println!("{}", p.question);
            let mut guess = String::new();
            io::stdin()
                .read_line(&mut guess)
                .expect("Failed to read guess");
            let answer = Answer {
                expected: p.answer.clone(),
                actual: guess.trim().to_string(),
            };
            ans.lock().unwrap().push(answer);
        }
        state_tx.send(GameState::Complete).unwrap();
    });

    match state_rx.recv_timeout(Duration::from_secs(game_time)) {
        Ok(GameState::Complete) => {
            io::stdout().flush().unwrap();
            println!("\nYou answered all the questions!");
        }
        Err(_) => {
            io::stdout().flush().unwrap();
            println!("\nYour time is up!");
        }
    };

    let answers = answers.lock().unwrap();
    let correct_answers: Vec<bool> = answers
        .iter()
        .filter_map(|a| {
            if a.expected == a.actual {
                Some(true)
            } else {
                None
            }
        })
        .collect();

    println!(
        "you got {} answers correct out of {}",
        correct_answers.len(),
        num_problems
    );
    Ok(())
}
