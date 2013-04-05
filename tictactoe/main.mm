//
//  main.cpp
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
    
    return true;
}

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

bool applySurface (int x, int y, SDL_Surface* source, SDL_Surface* dest)
{
    SDL_Rect offset;
    
    offset.x = x;
    offset.y = y;
    
    if (SDL_BlitSurface(source, NULL, dest, &offset) == -1)
    {
        return false;
    }
    
    return true;
}

void quitProgram()
{
    TTF_CloseFont(myfont);
    TTF_Quit();
    SDL_Quit();
}

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
    applySurface(0, 0, xToken, screen);
    applySurface(200, 200, oToken, screen);
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
        }
    }
    
    quitProgram();
    return 0;
}

