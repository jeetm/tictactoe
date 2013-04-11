//  main.mm
//  tictactoe
//  Created by Jeet Mehta on 2013-04-04.
//  Copyright (c) 2013 Jeet Mehta. All rights reserved.

#include <iostream>
#include <vector>
#include <SDL/SDL.h>
#include <SDL_image/SDL_image.h>
#include <SDL_ttf/SDL_ttf.h>

//Screen Size global variables
const int SCREEN_WIDTH = 600;
const int SCREEN_HEIGHT = 600;
const int SCREEN_BPP = 32;

//Declaring the grid, screen and x/o images
SDL_Surface* screen = NULL;
SDL_Surface* xToken = NULL;
SDL_Surface* oToken = NULL;
SDL_Surface* gameGrid = NULL;
SDL_Surface* playAgain = NULL;

//Font Declaration
TTF_Font* myfont = NULL;
SDL_Surface* titleMessage = NULL;
SDL_Surface* winnerMessageX = NULL;
SDL_Surface* winnerImageX = NULL;
SDL_Surface* winnerImageO = NULL;
SDL_Surface* tieImage = NULL;
SDL_Surface* winnerMessageO = NULL;
SDL_Surface* drawMessage = NULL;
SDL_Color titleColor = {255, 255, 255};

//Game-Related Variables
bool squaresOccupied[10] = {false};
char boardX[3][3];
char boardO[3][3];
int turnNumber;
bool boardFilled;

//Event Declaration
SDL_Event event;

//Initialization Function
bool init()
{
    if (SDL_Init(SDL_INIT_EVERYTHING) == -1)
    {
        return false;
    }
    
    screen = SDL_SetVideoMode(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, SDL_SWSURFACE);
    
    if (screen == NULL)
    {
        return false;
    }
    
    if (TTF_Init() == -1)
    {
        return false;
    }
    
    SDL_WM_SetCaption("Tic Tac Toe", NULL);
    
    return true;
}

//Load Image Function
SDL_Surface* loadImages(std:: string filename, bool colorKey, int red, int blue, int green)
{
    SDL_Surface* inputImage = NULL;
    SDL_Surface* outputImage = NULL;
    
    inputImage = IMG_Load(filename.c_str());
    if (inputImage != NULL)
    {
        outputImage = SDL_DisplayFormat(inputImage);
        SDL_FreeSurface(inputImage);
        
        if (outputImage != NULL)
        {
           //Code for Color keying
            if (colorKey == true)
            {
                Uint32 key = SDL_MapRGB(outputImage->format, red, blue, green);
                SDL_SetColorKey(outputImage, SDL_SRCCOLORKEY, key);
            }
        }
    }
    
    return outputImage;
}

//Function that checks which square was clicked
int checkSquareNumber (int locationX, int locationY)
{
    if (locationX > 0 &&  locationX < 200 && (locationY > 0 &&  locationY < 200))
    {
        return 1;
    }
    
    if (locationX > 200 &&  locationX < 400 && (locationY > 0 &&  locationY < 200))
    {
        return 2;
    }
    
    if (locationX > 400 &&  locationX < 600 && (locationY > 0 &&  locationY < 200))
    {
        return 3;
    }
    
    if (locationX > 0 &&  locationX < 200 && (locationY > 200 &&  locationY < 400))
    {
        return 4;
    }
    
    if (locationX > 200 &&  locationX < 400 && (locationY > 200 &&  locationY < 400))
    {
        return 5;
    }
    
    if (locationX > 400 &&  locationX < 600 && (locationY > 200 &&  locationY < 400))
    {
        return 6;
    }
    
    if (locationX > 0 &&  locationX < 200 && (locationY > 400 &&  locationY < 600))
    {
        return 7;
    }
    
    if (locationX > 200 &&  locationX < 400 && (locationY > 400 &&  locationY < 600))
    {
        return 8;
    }
    
    if (locationX > 400 &&  locationX < 600 && (locationY > 400 &&  locationY < 600))
    {
        return 9;
    }
    
    return 0;
}

//Function that checks if playAgain was clicked
bool willPlayAgain(int locationX, int locationY)
{
    if (locationX > 365 && locationX < 465 && (locationY > 325 && locationY < 367))
        {
            return true;
        }
    return false;
}

//Function that takes in images and offsets and applies them
bool applySurface (int x, int y, SDL_Surface* source, SDL_Surface* dest)
{
    SDL_Rect offset;
    
    offset.x = x;
    offset.y = y;
    
    if (SDL_BlitSurface(source, NULL, dest, &offset) == -1)
    {
        return false;
    }
    
    SDL_Flip(screen);
    return true;
}

//Converts square Number to offsets
void numConverter (int squareNumber, int &offsetX, int &offsetY)
{
    if (squareNumber == 1)
    {
        offsetX = 0;
        offsetY = 0;
    }
    if (squareNumber == 2)
    {
        offsetX = 200;
        offsetY = 0;
    }
    if (squareNumber == 3)
    {
        offsetX = 400;
        offsetY = 0;
    }
    if (squareNumber == 4)
    {
        offsetX = 0;
        offsetY = 200;
    }
    if (squareNumber == 5)
    {
        offsetX = 200;
        offsetY = 200;
    }
    if (squareNumber == 6)
    {
        offsetX = 400;
        offsetY = 200;
    }
    if (squareNumber == 7)
    {
        offsetX = 0;
        offsetY = 400;
    }
    if (squareNumber == 8)
    {
        offsetX = 200;
        offsetY = 400;
    }
    if (squareNumber == 9)
    {
        offsetX = 400;
        offsetY = 400;
    }
}

//Function that check's if there is a winner and returns whether its a winning combination or not
int CheckForWinner( char spaces[][3] )
{
	//Check Rows
	for( int i = 0; i < 3; i++)
	{
        for (int j = 0; j < 3; j+=3)
        {
            if ( spaces[i][j] == 'X' && spaces[i][j+1] == 'X' && spaces[i][j+2] == 'X')
                return 1;
            else if ( spaces[i][j] == 'O' && spaces[i][j+1] == 'O' && spaces[i][j+2] == 'O')
                return 2;
        }
	}
    
    //Check Columns
    for( int i = 0; i < 3; i++)
	{
        for (int j = 0; j < 3; j++)
        {
            if ( spaces[i][j] == 'X' && spaces[i+1][j] == 'X' && spaces[i+2][j] == 'X')
                return 1;
            else if ( spaces[i][j] == 'O' && spaces[i+1][j] == 'O' && spaces[i+2][j] == 'O')
                return 2;
            i=0;
        }
        break;
	}
    
    //Check Diagonals
    if (spaces[0][0] == 'X' && spaces[1][1] == 'X' && spaces[2][2] == 'X')
        return 1;
    else if (spaces[0][0] == 'O' && spaces[1][1] == 'O' && spaces[2][2] == 'O')
        return 2;
    else if (spaces[0][2] == 'X' && spaces[1][1] == 'X' && spaces[2][0] == 'X')
        return 1;
    else if (spaces[0][2] == '0' && spaces[1][1] == 'O' && spaces[2][0] == 'O')
        return 2;
                                                                                                                                                                                                                                                                                                                                    
    return 0;
}

//Function that prints to the console all elements of an array, needed for de-bugging purposes
void printVector( const std::vector<int> &array)
{
    for(int i=0; i<array.size(); ++i)
        std::cout << array[i] << " ";
    std::cout <<std::endl;
    std::cout << "----------------"<<std::endl;
}

void printArray(int array[][2])
{
    //int num = sizeof(array) / sizeof(array[0]);
    for (int i = 0; i < 9; i++)
    {
        for (int j=0;j < 2; j++)
        {
            std::cout << array[i][j];
        }
    }
}

//Function that converts board numbers to array locations
void boardConverter (int squareNumber, int &oneD, int &twoD)
{
    if (squareNumber == 1)
    {
        oneD = 0;
        twoD = 0;
    }
    if (squareNumber == 2)
    {
        oneD = 0;
        twoD = 1;
    }
    if (squareNumber == 3)
    {
        oneD = 0;
        twoD = 2;
    }
    if (squareNumber == 4)
    {
        oneD = 1;
        twoD = 0;
    }
    if (squareNumber == 5)
    {
        oneD = 1;
        twoD = 1;
    }
    if (squareNumber == 6)
    {
        oneD = 1;
        twoD = 2;
    }
    if (squareNumber == 7)
    {
        oneD = 2;
        twoD = 0;
    }
    if (squareNumber == 8)
    {
        oneD = 2;
        twoD = 1;
    }
    if (squareNumber == 9)
    {
        oneD = 2;
        twoD = 2;
    }
}

//Checks if the board is filled up
bool gameFinished()
{
    for (int i = 1; i <= 9; i++)
    {
        if (squaresOccupied[i] == true)
            boardFilled = true;
        else if (squaresOccupied[i] == false)
        {
            boardFilled = false;
            return false;
        }  
    }
    
    if (boardFilled == true)
    {
        return true;
    }
   
    return false;
}

//Function that clears the elements of a 1-D integer array
void clearOneDArray(int array[])
{
    int size = sizeof(array) / sizeof(int);
    for (int i = 0; i < size; i++)
    {
        array[i] = 0;
    }
}

//Function that clears all the elements of a 3-D char array
void clearCharArray (char array[][3])
{
    int size = sizeof(array) / sizeof(int);
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            array[i][j] = 0;
        }
    }
}

//Function that sets all elements of a bool array to false
void clearBoolArray (bool array[])
{
    for (int i = 0; i < 10; i++)
    {
        array[i] = false;
    }
}

//Function that handles game logic
bool gameLogic(int squareNum, int &turnNum, char &resultingWinner, bool &tieOccured)
{
    int winner;
    int offsetX, counter = 0, offsetY, oneD, twoD = 0;
    bool boardFilled;
    if (turnNum % 2 != 0)
    {
        for (int i = 1; i <= 9; i++)
        {
            if (squareNum == i)
            {
                if (squaresOccupied[i] == false)
                {
                    numConverter(squareNum, offsetX, offsetY);
                    applySurface(offsetX, offsetY, oToken, screen);
                    turnNum++;
                    if (counter > 1)
                        counter = 0;
                    counter++;
                    squaresOccupied[i] = true;
                    boardFilled = gameFinished();
                    counter++;
                    
                    boardConverter(squareNum, oneD, twoD);
                    boardO[oneD][twoD] = 'O';
                    winner = CheckForWinner(boardO);
                    if (winner == 2)
                    {
                        std::cout << "O has won!";
                        resultingWinner = 'O';
                        tieOccured = false;
                        return true;
                    }
                    else if (winner == 0 && boardFilled == true)
                    {
                        std::cout << "It's a tie!";
                        resultingWinner = 'N';
                        tieOccured = true;
                        std::cout << tieOccured;
                        return false;
                    }
                }
            }
        }
    }
    else {
        for (int i = 1; i <= 9; i++)
        {
            if (squareNum == i)
            {
                if (squaresOccupied[i] == false)
                {
                    numConverter(squareNum, offsetX, offsetY);
                    applySurface(offsetX, offsetY, xToken, screen);
                    std::cout << offsetX << offsetY;
                    if (counter > 1)
                        counter = 0;
                    turnNum++;
                    squaresOccupied[i] = true;
                    boardFilled = gameFinished();
                    counter++;
                    
                    boardConverter(squareNum, oneD, twoD);
                    boardX[oneD][twoD] = 'X';
                    winner = CheckForWinner(boardX);
                    if (winner == 1)
                    {
                        std::cout << "X has won";
                        resultingWinner = 'X';
                        tieOccured = false;
                        return true;
                    }
                    else if (winner == 0 && boardFilled == true)
                    {
                        std::cout << "It's a tie!";
                        resultingWinner = 'N';
                        tieOccured = true;
                        return false;
                    }
                }
            }
        }
    }
    
    return false;
}

//Quits all related systems
void quitProgram()
{
    TTF_CloseFont(myfont);
    TTF_Quit();
    SDL_Quit();
}

//Function that will handle all events
void handleEvents(SDL_Event event, bool keepPlaying)
{
    bool quit, tieHappen;
    int x,y, squareClicked;
    char overallWinner;
    
    if (event.type == SDL_MOUSEBUTTONDOWN)
    {
        if (event.button.button == SDL_BUTTON_LEFT)
        {
            x = event.button.x;
            y = event.button.y;
            
            if (willPlayAgain(x, y) == false)
            {
                squareClicked = checkSquareNumber(x, y);
                quit = gameLogic(squareClicked, turnNumber, overallWinner, tieHappen);
            }
            else if (willPlayAgain(x, y) == true)
            {
                applySurface(0, 0, gameGrid, screen);
                applySurface(160, 0, titleMessage, screen);
                SDL_Flip(screen);
                clearBoolArray(squaresOccupied);
                clearCharArray(boardO);
                clearCharArray(boardX);
                turnNumber = 0;
                boardFilled = false;
                //playAgain = false;
            }
            
            //Winner was Decided
            if (quit == true && tieHappen == false)
            {
                if (overallWinner == 'X')
                {
                    applySurface(170, 250, winnerImageX, screen);
                    applySurface(365, 325, playAgain, screen);
                    SDL_Flip(screen);
//                    if (event.type == SDL_MOUSEBUTTONDOWN)
//                    {
//                        if (event.button.button == SDL_BUTTON_LEFT)
//                        {
//                            x = event.button.x;
//                            y = event.button.y;
//                            
//                            if (willPlayAgain(x, y))
//                            {
//                                std::cout << "play again button was clicked";
//                                keepPlaying = true;
//                            }
//                            else {
//                                keepPlaying = false;
//                            }
//                        }
//                    }
//                    if (playAgain == false)
//                    {
//                        quitProgram();
//                    }
                }
                
                if (overallWinner == 'O')
                {
                    applySurface(170, 250, winnerImageO, screen);
                    applySurface(365, 325, playAgain, screen);
                    SDL_Flip(screen);
//                    if (event.type == SDL_MOUSEBUTTONDOWN)
//                    {
//                        if (event.button.button == SDL_BUTTON_LEFT)
//                        {
//                            x = event.button.x;
//                            y = event.button.y;
//                            
//                            if (willPlayAgain(x, y))
//                            {
//                                keepPlaying = true;
//                            }
//                            else {
//                                keepPlaying = false;
//                            }
//                        }
//                    }
//                    if (playAgain == false)
//                    {
//                        quitProgram();
//                    }
                }
            }

            else if (overallWinner == 'N')
            {
                std::cout<<overallWinner<<tieHappen;
                applySurface(170, 250, tieImage, screen);
                applySurface(365, 325, playAgain, screen);
//                if (event.type == SDL_MOUSEBUTTONDOWN)
//                {
//                    if (event.button.button == SDL_BUTTON_LEFT)
//                    {
//                        x = event.button.x;
//                        y = event.button.y;
//                        
//                        if (willPlayAgain(x, y))
//                        {
//                            keepPlaying = true;
//                        }
//                        else {
//                            keepPlaying = false;
//                        }
//                    }
//                }
//                if (playAgain == false)
//                {
//                    quitProgram();
//                }
            }
            

        }
    }
}

//Function which loads all necessary files
bool loadFiles()
{
    gameGrid = loadImages("grid.png", false, 0, 0, 0);
    xToken = loadImages("x.png", true, 255, 0, 255);
    oToken = loadImages("o.png", true, 255, 0, 255);
    winnerImageX = loadImages("xwinner.png", false, 0, 0, 0);
    winnerImageO = loadImages("owinner.png", false, 0, 0, 0);
    tieImage = loadImages("draw.png", false, 0 , 0, 0);
    playAgain = loadImages("playagain.png", true, 0, 0, 0);
    
    if (gameGrid == NULL || xToken == NULL || oToken == NULL || winnerImageO == NULL || winnerImageX == NULL || tieImage == NULL)
    {
        std::cout << "some images didn't load";
        return false;
    }
    
    myfont = TTF_OpenFont("stocky.TTF", 50);
    
    if (myfont == NULL)
    {
        return false;
    }

    return true;
}

//Main Progam
int main(int argc, char ** argv)
{
    bool playAgain = true;
    while (playAgain == true)
    {
        bool quit = false;
    
        if (init() == false)
        {
            return -1;
        }
        
        if (loadFiles() == false)
        {
            return -1;
        }
        
        titleMessage = TTF_RenderText_Solid(myfont, "Tic Tac Toe", titleColor);
        
        applySurface(0, 0, gameGrid, screen);
        applySurface(160, 0, titleMessage, screen);
        
        SDL_Flip(screen);
        
        while (quit == false)
        {
            while (SDL_PollEvent(&event))
            {
                if (event.type == SDL_QUIT)
                {
                    playAgain = false;
                    quit = true;
                }
                handleEvents(event, &playAgain);
            }
        }
    }

    quitProgram();
    return 0;
}

