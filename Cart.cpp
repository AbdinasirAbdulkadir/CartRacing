#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>

class Cart {
public:
    int position;

    Cart() : position(0) {}

    void move() {
        position += (std::rand() % 10) + 1;  // Move the cart forward by a random number of spaces (between 1 and 10)
    }
};

class CartGameEngine {
private:
    std::vector<Cart> carts;
    bool game_over;

public:
    CartGameEngine() : game_over(false) {
        std::srand(std::time(nullptr));  // Seed for random number generation
    }

    void startGame(int numberOfCarts) {
        for(int i = 0; i < numberOfCarts; ++i) {
            carts.push_back(Cart());
        }
        game_over = false;
    }

    bool updateGameState() {
        for (auto& cart : carts) {
            cart.move();
            if (cart.position >= 100) {  // assuming 100 is the length of the track
                game_over = true;
                return true;  // game over, a cart has won
            }
        }
        return false;  // game continues
    }

    void getPositions(int* positions, int size) {
        for (int i = 0; i < size && i < carts.size(); ++i) {
            positions[i] = carts[i].position;
        }
    }

    bool isGameOver() {
        return game_over;
    }
};

extern "C" {  // functions accessible from FFI
    CartGameEngine GameEngine;  // Global instance

    void start_game(int numberOfCarts) {
        GameEngine.startGame(numberOfCarts);
    }

    bool update_game() {
        return GameEngine.updateGameState();
    }

    void get_positions(int* positions, int size) {
        GameEngine.getPositions(positions, size);
    }

    bool is_game_over() {
        return GameEngine.isGameOver();
    }
}
