{
  machines = {
    pu500c = {
      system = "x86_64-linux";
      users = [ "jun" ];
    };
    um480xt = {
      system = "x86_64-linux";
      users = [ "kinos" ];
    };
    demo = {
      system = "x86_64-linux";
      users = [ "demo" ];
      placeholder = true;
    };
    arch = {
      system = "x86_64-linux";
      users = [ "arch" ];
      nixos = false;
      placeholder = true;
    };
  };
}
