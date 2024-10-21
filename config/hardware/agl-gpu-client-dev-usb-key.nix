
let 
  # Import hardware configuration based on the provided hostname config file

  ## Also possible to import from a separate file
  # hardware = import ;
  # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
  # swap-luks-uuid = hardware.luks-swap-uuid;


  bs = 1;
  offset-m = 14900;
  offset-b = 15623782400;
  keyfile-size = 4096;

in {

}
