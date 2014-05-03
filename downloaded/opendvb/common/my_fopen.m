function fid = my_fopen (filename, mode)

  switch computer
    case 'PCWIN'
      filename = strrep(filename, '/', char(92));
  end
  
  [fid, msg] = fopen (filename, mode);

  if fid == -1
    fprintf ('Cannot open file: %s\n', filename);
    fprintf ('Reason: %s\n', msg);
    
    error ('stop');
  end
  