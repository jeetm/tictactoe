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

int main(int argc, char ** argv)
{
    SDL_Quit();
    TTF_Quit();
    return 0;
}

