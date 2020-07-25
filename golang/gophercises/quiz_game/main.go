package main

import (
	"bufio"
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"os"
)

// Answer is an answer to a question
type Answer struct {
	expected string
	actual   string
}

func correctAnsers(as []Answer) int {
	result := 0
	for _, answer := range as {
		if answer.expected == answer.actual {
			result = result + 1
		}
	}
	return result
}

func main() {
	loc := flag.String("loc", "problems.csv", "The location of the csv file, where the first column is the question and the second column is the answer")
	flag.Parse()

	csvFile, err := os.Open(*loc)
	defer csvFile.Close()
	reader := csv.NewReader(bufio.NewReader(csvFile))
	if err != nil {
		fmt.Println("Couldn't open problem file")
	}

	var answers []Answer
	for {
		line, err := reader.Read()
		if err == io.EOF {
			break
		}
		fmt.Printf("%v? \n", line[0])
		var guess string
		fmt.Scanln(&guess)

		answers = append(answers, Answer{
			expected: line[1],
			actual:   guess,
		})
	}

	fmt.Printf("You got %v out of %v correct!", len(answers), len(answers))
}
