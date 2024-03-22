package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// Position represents a position on the game board
type Position struct {
	x, y int
}

// PlayerType represents the type of player (Police or Thief)
type PlayerType int

const (
	policePerson PlayerType = iota + 1
	thiefPerson
)

// PlayerInfo stores information about a player
type PlayerInfo struct {
	person PlayerType
	pos    Position
}

// Global variables
var (
	n, m, s int            // Board dimensions and move limit
	wg      sync.WaitGroup // Waitgroup for synchronization

)

func main() {
	rand.Seed(time.Now().UnixNano())                                             // Seed for random number generation
	n = rand.Intn(191) + 10                                                      // Random board rows [10, 200]
	m = rand.Intn(191) + 10                                                      // Random board columns [10, 200]
	s = rand.Intn(10*findthemax(n, m)-2*findthemax(n, m)+1) + 2*findthemax(n, m) // Random move limit [2*max(n, m), 10*max(n, m)]

	fmt.Printf("Starting Police and Thief game with %dx%d board\n", n, m)
	fmt.Printf("Police has %d moves to catch the thief\n", s)

	// Initialize positions for police and thief
	policePos := Position{0, 0}        // Starting position for police
	thiefPos := Position{n - 1, m - 1} // Starting position for thief

	// Create playerInfo structs for police and thief
	police := PlayerInfo{person: policePerson, pos: policePos}
	thief := PlayerInfo{person: thiefPerson, pos: thiefPos}

	controller := make(chan PlayerInfo) // Channel for communication between players and controller
	gameisDone := make(chan struct{})   // Channel to signal end of game

	wg.Add(1)
	go policePlayer(controller, gameisDone)
	go thiefPlayer(controller, gameisDone)
	go gameController(controller, gameisDone, police, thief)

	wg.Wait() // Wait for all goroutines to finish

}

// Police player function
func policePlayer(controller chan<- PlayerInfo, gameisDone chan struct{}) {
	pos := Position{0, 0} // Start position for police
	for {
		select {
		case <-gameisDone:
			return // Game ended
		default:
			pos = randomMove(pos) // Random move for police
			controller <- PlayerInfo{person: policePerson, pos: pos}
		}
	}
}

// Thief player function
func thiefPlayer(controller chan<- PlayerInfo, gameisDone chan struct{}) {
	pos := Position{n - 1, m - 1}                           // Start position for thief
	controller <- PlayerInfo{person: thiefPerson, pos: pos} // Send the initial position
	for {
		select {
		case <-gameisDone:
			return // Game ended
		default:
			pos = randomMove(pos) // Random move for thief
			controller <- PlayerInfo{person: thiefPerson, pos: pos}
		}
	}
}

// Game controller function
func gameController(controller <-chan PlayerInfo, gameisDone chan struct{}, police, thief PlayerInfo) {
	defer wg.Done()
	moves := 0 // Initialize moves counter

	for move := range controller {

		if s == 0 { // Police player is out of moves
			fmt.Println("The Police ran out of moves and the Thief won the game.")
			close(gameisDone) // End the game by closing the channel
			return
		}

		// Update positions
		if move.person == policePerson {
			police.pos = move.pos
			s--
		} else {
			thief.pos = move.pos
		}

		// Print game status each turn, an addition is the number of moves left from the Police Player
		//knowing how the Go is not sequencial the Police player may not lose a move each turn as some turns the Theif is moving
		fmt.Printf("The Police Position = (%d, %d), The Thief Position = (%d, %d), The Police player has %d moves left \n",
			police.pos.x, police.pos.y, thief.pos.x, thief.pos.y, s)

		// Increment moves counter
		moves++

		// Check game status
		if !checkGameStatus(police.pos, thief.pos, moves) {
			close(gameisDone) // End the game by closing the channel
			return
		}
	}
}

// checks status of the game
func checkGameStatus(policePos, thiefPos Position, moves int) bool {
	if policePos.x == 0 && policePos.y == 0 && thiefPos.x == 0 && thiefPos.y == 0 { // Both player meet at the very top left cell
		if moves%2 == 0 {
			fmt.Println("The game ends in a tie.")
			return false
		}
	} else if thiefPos.x == 0 && thiefPos.y == 0 { //Theif has arrived to the top left cell without being caught
		fmt.Println("The Thief escaped and won the game.")
		return false
	} else if policePos.x == thiefPos.x && policePos.y == thiefPos.y { //The police has moved into a cell where the Theif is present, not being the top left cell
		fmt.Printf("The Police caught the Thief at (%d, %d) and won the game.\n", policePos.x, policePos.y)
		return false
	}

	return true
}

// Generate a random move based on current position
func randomMove(pos Position) Position {
	for {
		newPos := pos // Create a new position based on the current position

		// Choose a random direction
		switch rand.Intn(4) {
		case 0: // Move left
			if pos.y > 0 {
				newPos.y--
			}
		case 1: // Move down
			if pos.x < n-1 {
				newPos.x++
			}
		case 2: // Move right
			if pos.y < m-1 {
				newPos.y++
			}
		case 3: // Move up
			if pos.x > 0 {
				newPos.x--
			}
		}

		// Check if the new position is different from the current position
		if newPos != pos {
			return newPos // Valid move, return the new position
		}
	}
}

// Function to find the maximum of two integers
func findthemax(a, b int) int {
	if a > b {
		return a
	}
	return b
}
