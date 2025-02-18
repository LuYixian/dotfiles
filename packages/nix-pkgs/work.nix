{ pkgs, ... }: {
  # TODO Fell free to add the packages for your work here.
  environment.systemPackages = with pkgs; [
    aws-sam-cli
    azure-cli
    azure-functions-core-tools
    mariadb
    mysql84
    postgresql
    postgresql_16
    postgresql_15
    postgresql_14
    poetry
    redis
    tflint
    volta
  ];
  environment.variables.EDITOR = "nvim";
}