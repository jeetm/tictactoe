//
//  main.mm
//  tictactoe
//
//  Created by Jeet Mehta on 2013-04-04.
//  Copyright (c) 2013 Jeet Mehta. All rights reserved.
//

#include <iostream>
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

//Font Declaration
TTF_Font* myfont = NULL;
SDL_Surface* titleMessage = NULL;
SDL_Color titleColor = {255, 255, 255};

//Game-Related Variables
bool squaresOccupied[9] = {false};
int winningCombinations[8][3] = {{1,2,3}, {4,5,6}, {7,8,9}, {1,4,7}, {2,5,8}, {3,6,9}, {1,5,9}, {3,5,7}};
int squaresFilled[8][3];
int turnNumber;


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
SDL_Surface* loadImages(std:: string filename, bool colorKey)
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
                Uint32 key = SDL_MapRGB(outputImage->format, 255, 0, 255);
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

bool checkWinner()
{
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            
        }
    }
}

//Function that handles game logic
void gameLogic(int squareNum, int turnNum)
{
    int offsetX, offsetY = 0;
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
                    squaresOccupied[i] = true;
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
                    squaresOccupied[i] = true;
                }
            }
        }
    }
}

//Function that will handle all events
void handleEvents(SDL_Event event)
{
    int x,y, squareClicked;
    
    if (event.type == SDL_MOUSEBUTTONDOWN)
    {
        if (event.button.button == SDL_BUTTON_LEFT)
        {
            x = event.button.x;
            y = event.button.y;
            
            squareClicked = checkSquareNumber(x, y);
            gameLogic(squareClicked, turnNumber);
            turnNumber++;
        }
    }
}

//Function which loads all necessary files
bool loadFiles()
{
    gameGrid = loadImages("grid.png", false);
    xToken = loadImages("x.png", true);
    oToken = loadImages("o.png", true);
    
    if (gameGrid == NULL || xToken == NULL || oToken == NULL)
    {
        return false;
    }
    
    myfont = TTF_OpenFont("stocky.TTF", 50);
    
    if (myfont == NULL)
    {
        return false;
    }

    return true;
}


//Quits all related systems
void quitProgram()
{
    TTF_CloseFont(myfont);
    TTF_Quit();
    SDL_Quit();
}

//Main Progam
int main(int argc, char ** argv)
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
                quit = true;
            }
            handleEvents(event);
        }
    }
    
    quitProgram();
    return 0;
}

