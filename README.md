# cps-scheme
Adventures into bizzare world of continutations in Scheme

## call/cc Hello World

```Scheme

(((call/cc (lambda (x) x)) (lambda (x) x)) "Hello World")

```


## Links
 - http://community.schemewiki.org/?call-with-current-continuation
 - https://en.wikipedia.org/wiki/Call-with-current-continuation
 - http://c2.com/cgi/wiki?CallWithCurrentContinuation
 - http://matt.might.net/articles/programming-with-continuations--exceptions-backtracking-search-threads-generators-coroutines/
