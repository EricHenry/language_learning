package main

import (
	"bufio"
	"encoding/csv"
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
	csvFile, err := os.Open("problems.csv")
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
