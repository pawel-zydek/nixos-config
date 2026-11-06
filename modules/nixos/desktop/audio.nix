{ config, lib, ... }:
let
  cfg = config.my.audio;
in
{
  options.my.audio.enable = lib.mkEnableOption "dźwięk (PipeWire)";

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
