package com;


/**
 * ...
 * @author Joaquin
 */
#if (flash)
typedef MyList<T> =Array<T>;
#else
typedef MyList<T> = Array<T>;
#end
