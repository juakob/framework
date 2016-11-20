package com;


/**
 * ...
 * @author Joaquin
 */
#if (flash)
typedef MyList<T> =flash.Vector<T>;
#else
typedef MyList<T> = Array<T>;
#end
