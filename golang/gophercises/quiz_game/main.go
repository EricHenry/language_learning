package main

import (
	"bufio"
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"os"
	"strings"
	"time"
)

// Answer is an answer to a question
type Answer struct {
	expected string
	actual   string
}

func cleanString(s string) string {
	return strings.ToLower(strings.Trim(s, " "))
}

func correctAnsers(as []Answer) int {
	result := 0
	for _, answer := range as {
		if cleanString(answer.expected) == cleanString(answer.actual) {
			result = result + 1
		}
	}
	return result
}

func startTimer(secs time.Duration, c chan string) {
	time.Sleep(secs)
	fmt.Println("CLOSING, times up")
	c <- "Times Up"
	close(c)
}

func runGame(as *[]Answer, r *csv.Reader, c chan string) {
	for {
		line, err := r.Read()
		if err == io.EOF {
			break
		}
		fmt.Printf("%v? \n", line[0])
		var guess string
		fmt.Scanln(&guess)

		*as = append(*as, Answer{
			expected: line[1],
			actual:   guess,
		})
	}
	fmt.Println("CLOSING, game loop complete")
	c <- "Completed"
	close(c)
}

func main() {
	loc := flag.String("loc", "problems.csv", "The location of the csv file, where the first column is the question and the second column is the answer")
	gameTime := flag.Uint("game-time", 30, "The game time in seconds.")
	flag.Parse()

	csvFile, err := os.Open(*loc)
	defer csvFile.Close()
	reader := csv.NewReader(bufio.NewReader(csvFile))
	if err != nil {
		fmt.Println("Couldn't open problem file")
	}

	fmt.Println("Welcome to the Quiz Game!")
	fmt.Printf("You will have %v seconds to complete as many questions as you can\n", *gameTime)
	for {
		fmt.Println("Are you ready to start the game? (y/n)")
		var ready string
		fmt.Scanln(&ready)

		if ready == "y" {
			break
		}
	}

	var answers []Answer
	gameDuration := time.Duration(*gameTime) * time.Second
	gameStatus := make(chan string, 1)
	go startTimer(gameDuration, gameStatus)
	go runGame(&answers, reader, gameStatus)

	for status := range gameStatus {
		switch status {
		case "Times Up":
			fmt.Println("\nTime ran out!")
			break
		case "Complete":
			fmt.Println("\nAnswered all questions!")
			break
		}
	}

	fmt.Printf("You got %v out of %v correct!\n", correctAnsers(answers), len(answers))
}
