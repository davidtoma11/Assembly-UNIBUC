# Conway's Game of Life - Symmetric Encryption

## Introduction
Conway’s Game of Life is a two-dimensional zero-player game invented by mathematician John Horton Conway in 1970. The game simulates the evolution of a cellular system based on an initial configuration and predefined rules. This system is Turing-complete.

## Rules of the System
The state of the system is represented as a grid where each cell can be either alive (1) or dead (0). The evolution follows these rules:

1. **Underpopulation**: Any live cell with fewer than two live neighbors dies in the next generation.
2. **Survival**: Any live cell with two or three live neighbors remains alive in the next generation.
3. **Overpopulation**: Any live cell with more than three live neighbors dies in the next generation.
4. **Reproduction**: Any dead cell with exactly three live neighbors becomes a live cell in the next generation.
5. **Dead Cell Continuity**: Any other dead cell remains dead.

A cell's neighbors are the eight surrounding cells in the matrix:
```
a00 a01 a02
a10  cell a12
a20 a21 a22
```

The system state at generation `n` is defined as an `m x n` matrix `S_n` where `0` represents a dead cell and `1` represents a live cell.

A `k`-evolution (k ≥ 0) is defined as an iteration sequence `S0 → S1 → ... → Sk`, where each `S(i+1)` is derived from `Si` by applying the above rules.

**Note:** Cells at the matrix borders are considered to have dead neighbors outside the matrix.

## Symmetric Encryption Scheme
A symmetric encryption key is generated based on an initial configuration `S0` and a `k`-evolution. The key is obtained by flattening the extended matrix `Sk` into a one-dimensional bit sequence.

### Encryption Process
Given a plaintext message `m`, encryption `{m}<S0,k>` is performed by XOR-ing the message with the generated key:
- If the message and key have the same length, XOR is applied element-wise.
- If the message is shorter, only the corresponding portion of the key is used.
- If the message is longer, the key is repeated as needed.

### Example
**Given:**
- Initial matrix `S0`:
  ```
  0 1 1 0
  1 0 0 0
  0 0 1 1
  ```
- After one iteration `S1`, the key extracted is:
  ```
  000000001000000010000000000000
  ```
- Message `m = "parola"`:
  ```
  p  01110000
  a  01100001
  r  01110010
  o  01101111
  l  01101100
  a  01100001
  ```
- XOR-ing with the key results in:
  ```
  0x70E1F26F6E63
  ```

## Task Requirements
### Task 0x00 - 5 points
#### Input:
- `m` (number of rows)
- `n` (number of columns)
- `p` (number of live cells)
- `p` live cell coordinates
- `k` (number of generations to simulate)

#### Output:
- The final state of the system after `k` generations, formatted as a matrix.

**Example:**
**Input:**
```
3
4
5
0 1
0 2
1 0
2 2
2 3
5
```
**Output:**
```
0 0 0 0
0 0 0 0
0 0 0 0
```

### Task 0x01 - 2.5 points
#### Input:
- `m`, `n`, `p`, `p` live cell coordinates, `k`
- `o` (0 for encryption, 1 for decryption)
- `m` (plaintext or hex-encoded ciphertext)

#### Output:
- Encrypted message (if `o = 0`)
- Decrypted message (if `o = 1`)

**Example:**
**Encryption Input:**
```
3
4
5
0 1
0 2
1 0
2 2
2 3
1
0
parola
```
**Output:**
```
0x70E1F26F6E63
```

**Decryption Input:**
```
3
4
5
0 1
0 2
1 0
2 2
2 3
1
1
0x70E1F26F6E63
```
**Output:**
```
parola
```

## Notes
- Input should be read from `STDIN`, and output should be printed to `STDOUT`.
- To avoid manually entering long inputs, create a file (e.g., `input.txt`) and use:
  ```
  ./task00 < input.txt
  ```
- Ensure all output strings end with `\n`.

## Constraints
- `1 ≤ m, n ≤ 18`
- `p ≤ m * n`
- `k ≤ 15`
