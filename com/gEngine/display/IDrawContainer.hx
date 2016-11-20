package com.gEngine.display;

/**
 * @author Joaquin
 */
interface IDrawContainer extends IDraw
{
   function remove(aChild:IDraw):Void; 
}