function assert (predicate, subsystem, message)

  if ~ all(all(predicate))
    close all;
    
    fprintf ('%s: Error: Assertion failed.\n', subsystem);
    fprintf ('%s: %s\n', subsystem, message);
    
    error ('stop');
  end