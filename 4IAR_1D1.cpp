/* there are a few notes to make this code work
1.this version only uses 1D array:   a[i][j]=a[i*7+j]
2. use char instead of string
3. not allow to use multiple conditions in a if-else statement
4. no boolean function allowed
5. no cout --> replace by printChar, printString, printChar(a[i])
5. no cin --> replace by readChar
6. not allow passing "int& b", "char c"
7. only "if" statement. not allow "else" statement
*/

#include <iostream>
#include <time.h>
using namespace std;
#define printCharc(x) printf("%c", x)
#define printChard(x) printf("%d", x)
#define printString(x) printf("%s", x)
#define readChar(x) scanf("%d", &x)

static int wrong_move_2 = 0;
static int wrong_move_1 = 0;
static int *Prev = new int[50];
static int prev_Idx = -1;
static int undo1 = 0;
static int undo2 = 0;
static int key = 1;
static char *piece = new char[3];
// void setWinner(char op)
// {
//     printCharc(op);
//     printString(" is the winner!!!");
// }
int fullColumn(char *a, int col)
{
    if (a[col] != ' ')
    {
        return 1;
    }
    return 0;
}
int fullTable(char *a)
{
    // for (int j = 0; j < 7; j++)
    // {
    //     if (!fullColumn(a, j))
    //     {
    //         return 0;
    //     }
    // }
    // return 1;
    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            if (a[7 * i + j] == ' ')
            {
                return 0;
            }
        }
    }
    return 1;
}
int winCheck(char *a, int player)
{
    for (int r = 0; r < 6; r++)
    {
        for (int c = 0; c < 7; c++)
        {
            // check null space
            if (a[r * 7 + c] == ' ')
            {
                continue;
            }
            char cur = a[r * 7 + c];
            // check vertically to Upper tokens
            if (r + 3 < 6)
            {
                if (a[(r + 1) * 7 + c] == cur)
                {
                    if (a[(r + 2) * 7 + c] == cur)
                    {
                        if (a[(r + 3) * 7 + c] == cur)
                        {
                            // setWinner(cur);
                            cout << "Player " << player;
                            printString(" is the winner!!!\n");
                            return 1;
                        }
                    }
                }
            }

            // check horizontally to right tokens
            if (c + 3 < 7)
            {
                if (a[(r)*7 + c + 1] == cur)
                {
                    if (a[(r)*7 + c + 2] == cur)
                    {
                        if (a[(r)*7 + c + 3] == cur)
                        {
                            // setWinner(cur);
                            cout << "Player " << player;
                            printString(" is the winner!!!\n");
                            return 1;
                        }
                    }
                }
            }

            // check diagonally Up-Left
            if (r + 3 < 6)
            {
                if (c - 3 >= 0)
                {
                    if (a[(r + 1) * 7 + c - 1] == cur)
                    {
                        if (a[(r + 2) * 7 + c - 2] == cur)
                        {
                            if (a[(r + 3) * 7 + c - 3] == cur)
                            {
                                // setWinner(cur);
                                cout << "Player " << player;
                                printString(" is the winner!!!\n");
                                return 1;
                            }
                        }
                    }
                }
            }

            // check diagonally Up-Right
            if (r + 3 < 6)
            {
                if (c + 3 < 7)
                {
                    if (a[(r + 1) * 7 + c + 1] == cur)
                    {
                        if (a[(r + 2) * 7 + c + 2] == cur)
                        {
                            if (a[(r + 3) * 7 + c + 3] == cur)
                            {
                                // setWinner(cur);
                                cout << "Player " << player;
                                printString(" is the winner!!!\n");
                                return 1;
                            }
                        }
                    }
                }
            }
        }
    }
    return 0;
}

void printBoard(char *a)
{
    for (int i = 0; i < 6; i++)
    {
        // cout << "|";
        printCharc('|');
        for (int j = 0; j < 7; j++)
        {
            // cout << a[i * 7 + j];
            printCharc(a[i * 7 + j]);
            if (j != 6)
            {
                // cout << " ";
                printCharc(' ');
            }
        }
        // cout << "|";
        printString("|\n");
        // cout << endl;
    }

    for (int i = 0; i < 2; i++)
    {
        // cout << " ";
        printCharc(' ');
        for (int j = 0; j < 7; j++)
        {
            if (i == 0)
            {
                // cout << "- ";
                printString("- ");
            }
            if (i == 1)
            {
                // cout << j << " ";
                printChard(j);
                printCharc(' ');
            }
        }
        // cout << endl;
        printCharc('\n');
    }
    // cout << endl<< endl;
    printString("\n\n");
}

// void newMove(char *a, int &col, char op)
// {
//     int row = 5;
//     while (a[row * 7 + col] != ' ')
//     {
//         row--;
//     }
//     a[row * 7 + col] = op;
//     if (winCheck(a))
//     {
//         col = -1;
//     }
// }
int over_wrong()
{
    if (wrong_move_1 == 3)

    {
        cout << "Violation: Inappropriate column 3 times. Player 1 lose!\n";
        cout << "Congratulations! Player 2 is the winner!!!\n";
        return 1;
    }
    if (wrong_move_2 == 3)
    {
        cout << "Violation: Inappropriate column 3 times. Player 2 lose!\n";
        cout << "Congratulations! Player 1 is the winner!!!\n";
        return 1;
    }
    return 0;
}
int over_undo1()
{
    if (undo1 == 3)
    {
        cout << "Player 1 is running out of UNDO move. Choose again!\n";
        return 1;
    }
    return 0;
}
int over_undo2()
{
    if (undo2 == 3)
    {
        cout << "Player 2 is running out of UNDO move. Choose again!\n";
        return 1;
    }
    return 0;
}
void turnSwitch(char *a)
{
    int col = 0; // init value of col

    while (col != -1)
    {
        // check1 here
        if (key == 1)
        {
            printString("Turn player 1.\nSelect column: ");
            readChar(col);
            // Undo process
            if (col == -5)
            {
                cout << "undo2: " << undo2 << endl;
                if (over_undo2() == 1)
                {
                    continue;
                }
                if (Prev[0] != -1)
                {
                    cout << "Undo!\n";
                    a[Prev[0]] = ' ';
                    undo2++;
                    printBoard(a);
                    Prev--;
                    key = 2;
                    continue;
                }
                // in below case, cannot undo anymore because the table is empty at the moment
                cout << "The table is empty, cannot UNDO. Choose again!\n";
                continue;
            }
            // end of undo process
            // Exception 1
            if (col < 0 || col > 6)
            {
                wrong_move_1++;
                if (over_wrong() == 1)
                {
                    break;
                }
                cout << "Inappropriate column! Choose again.\n\n";
                continue;
            }
            // adding
            // Exception 2
            if (fullColumn(a, col) == 1)
            {
                wrong_move_1++;
                if (over_wrong() == 1)
                {
                    break;
                }
                cout << "Inappropriate move: column is full! Please choose again.\n\n";
                continue;
            }

            // end of adding
            key = 2;
            // check2 here
            //  newMove(a, col, 'x');
            //  fill in the table
            int row = 5;
            while (a[row * 7 + col] != ' ')
            {
                row--;
            }
            // a[row * 7 + col] = 'x';
            a[row * 7 + col] = piece[1];
            // fill in the table_end
            // check3 here
            // Prev update
            Prev++;
            prev_Idx = row * 7 + col;
            Prev[0] = prev_Idx;
            // Prev update_end
            if (winCheck(a, 1))
            {
                printBoard(a);
                break;
            }
            printBoard(a);
            // check 4 here
            //  Exception 3
            if (fullTable(a) == 1)
            {
                cout << "DRAW!\n";
                break;
            }
            // check5 here
        }
        else if (key == 2)
        {
            printString("Turn player 2.\nSelect column: ");
            readChar(col);
            // Undo process
            if (col == -5)
            {
                cout << "undo1: " << undo1 << endl;
                if (over_undo1() == 1)
                {
                    continue;
                }
                if (Prev[0] != -1)
                {
                    cout << "Undo!\n";
                    a[Prev[0]] = ' ';
                    undo1++;
                    printBoard(a);
                    Prev--;
                    key = 1;
                    continue;
                }

                // in below case, cannot undo anymore because the table is empty at the moment
                cout << "The table is empty, cannot UNDO. Choose again!\n";
                continue;
            }
            // end of undo process
            // Exception 1
            if (col < 0 || col > 6)
            {
                wrong_move_2++;
                if (over_wrong() == 1)
                {
                    break;
                }
                cout << "Inappropriate column! Choose again.\n\n";
                continue;
            }
            // adding
            // Exception 2
            if (fullColumn(a, col) == 1)
            {
                wrong_move_2++;
                if (over_wrong() == 1)
                {
                    break;
                }
                cout << "Inappropriate move: column is full! Please choose again.\n\n";
                continue;
            }

            // end of adding
            key = 1;

            // newMove(a, col, 'o');
            int row = 5;
            while (a[row * 7 + col] != ' ')
            {
                row--;
            }
            // a[row * 7 + col] = 'o';
            a[row * 7 + col] = piece[2];
            Prev++;
            prev_Idx = row * 7 + col;
            Prev[0] = prev_Idx;
            if (winCheck(a, 2))
            {
                printBoard(a);
                break;
            }
            printBoard(a);
            // Exception 3
            if (fullTable(a) == 1)
            {
                cout << "DRAW!\n";
                break;
            }
        }
    }
}
void pickPlayer()
{
    char temp = ' ';
    cout << "Randomly choose the starting player: ";
    srand(time(0));
    int random = 1 + rand() % 2;
    if (random == 1)
    {
        cout << "Player 1.\n";
        key = 1;
        while (temp != 'x' && temp != 'o')
        {
            cout << "Please pick the piece (X or O) ? : ";
            cin >> temp;
            if (temp == 'x')
            {
                piece[1] = 'x';
                piece[2] = 'o';
            }
            else if (temp == 'o')
            {
                piece[1] = 'o';
                piece[2] = 'x';
            }
            else
            {
                cout << "Invalid piece. Choose again!\n";
            }
        }
    }
    else
    {
        cout << "Player 2.\n";
        key = 2;
        while (temp != 'x' && temp != 'o')
        {
            cout << "Please pick the piece (X or O) ? : ";
            cin >> temp;
            if (temp == 'x')
            {
                piece[1] = 'o';
                piece[2] = 'x';
            }
            else if (temp == 'o')
            {
                piece[1] = 'x';
                piece[2] = 'o';
            }
            else
            {
                cout << "Invalid piece. Choose again!\n";
            }
        }
    }
}
int main()
{
    // redefine printChar
    char a[] = "                                          "; // 42 spaces
    char b[] = "912345678901234567890123456789012345678901";

    printBoard(b);
    string temp;
    while (temp != "1")
    {
        cout << "Press 1 to start the game: ";
        cin >> temp;
    }
    pickPlayer();
    printBoard(a);
    // initializing
    Prev[0] = -1;
    turnSwitch(a);
    return 0;
}
// logic undo: tich hop trong luc input column. if column==-5 then undo. if column==
/*  ex: turn p1: 2
        turn p2: -5(undo for p1,delete 2 for p1,switch to p1)
        turn p1: ........
*/
/*  1.invalid column 0 <= x <= 6. bat nhap lai                  (checked)
    2. full column->  bat nhap (a[0][j]!=' '->column j is full) (checked)
    3. full het -> hoa (fullColumn with j=0 to 6)               (checked)
    4. di sai 3 lan -> lose                                     (checked)
    5. Undo when the table is empty                             (checked)
    6. Can only undo 3 times                                    (checked)
*/
/*Task to do:
 1. Build exception handler (checked)
 2. Build redo process      (checked)
 3. Build random choosing which player start first (checked)
 4. rebuild undo            (checked)
*/