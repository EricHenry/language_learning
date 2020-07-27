use std::fmt;
use std::fs::File;
use std::io::{self};
use std::sync::{mpsc, Arc, Mutex};
use std::thread;
use std::time::Duration;
use std::vec::Vec;

extern crate clap;
use clap::{App, Arg};

struct Problem {
    question: String,
    answer: String,
}

struct Answer {
    expected: String,
    actual: String,
}

enum GameState {
    TimeUp,
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

    println!("problems: {:?}", problems);
    // create a channel for communication
    let (tx, rx) = mpsc::channel();
    // clone the transmitter
    let tx1 = mpsc::Sender::clone(&tx);
    let answers: Arc<Mutex<Vec<Answer>>> = Arc::new(Mutex::new(Vec::new()));

    // timer thread, keeps track of the game time
    std::thread::spawn(move || {
        thread::sleep(Duration::from_secs(game_time));
        tx.send(GameState::TimeUp)
    });

    // main game loop
    let ans = Arc::clone(&answers);
    std::thread::spawn(move || {
        for p in problems.iter() {
            let mut ans = ans.lock().unwrap();
            println!("{}?", p.question);
            let mut guess = String::new();
            io::stdin()
                .read_line(&mut guess)
                .expect("Failed to read guess");
            ans.push(Answer {
                expected: p.answer.clone(),
                actual: guess.trim().to_string(),
            });
        }
        tx1.send(GameState::Complete)
    });

    for received in rx {
        match received {
            GameState::TimeUp => {
                println!("\nYour time is up!");
                break;
            }
            GameState::Complete => {
                println!("\nYou answered all the questions!");
                break;
            }
        }
    }
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
        answers.len()
    );
    Ok(())
}

impl fmt::Display for Problem {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "Problem ( question: {}, answer: {} )",
            self.question, self.answer
        )?;
        Ok(())
    }
}
impl fmt::Debug for Problem {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.debug_struct("Problem")
            .field("question", &self.question)
            .field("answer", &self.answer)
            .finish()
    }
}
impl fmt::Display for Answer {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "Answer ( expected: {}, actual: {} )",
            self.expected, self.actual
        )?;
        Ok(())
    }
}
impl fmt::Debug for Answer {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.debug_struct("Answer")
            .field("expected", &self.expected)
            .field("actual", &self.actual)
            .finish()
    }
}
