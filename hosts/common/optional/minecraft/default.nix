{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/opt/minecraft";
    openFirewall = true;
    servers = {
      "main" = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_4;
        autoStart = true;
        restart = "always";
        serverProperties = {
          server-port = 47000;
          difficulty = "normal";
          view-distance = 16;
        };
        jvmOpts = "-Xmx4G";
        files = {
          "config/inventoryessentials-common.toml".value = {
            allowBulkTransferAllOnEmptySlot = true;
            forceClientImplementation = false;
          };
          "config/configurabledespawntimer.json5" = {
            format = pkgs.formats.json { };
            value = {
              "globalItemDespawnTimeInTicks" = 24000;
              "globalExperienceOrbDespawnTimeInTicks" = 12000;
              "preventDespawnForPlayerItems" = false;
            };
          };
          "config/liteminer-common.toml" = pkgs.writeTextFile {
            name = "liteminer-common.toml";
            text = ''
              #:)
              prevent_tool_breaking = true
              #:)
              require_correct_tool_enabled = true
              #:)
              #Range: 1 ~ 2048
              block_break_limit = 64
              #:)
              harvest_time_per_block_modifier_enabled = true
              #:)
              #Range: 1.0 ~ 10.0
              harvest_time_per_block_modifier = 2.0
              #:)
              food_exhaustion_enabled = true
              #:)
              #Range: 0.0 ~ 1.0
              food_exhaustion = 0.2
            '';
          };
          "config/xaerominimap-common.txt" = pkgs.writeTextFile {
            name = "xaerominimap-common.txt";
            text = ''
              allowCaveModeOnServer:true
              allowNetherCaveModeOnServer:true
              allowRadarOnServer:true
              registerStatusEffects:false
              everyoneTracksEveryone:false
            '';
          };
          "config/xaeroworldmap-common.txt" = pkgs.writeTextFile {
            name = "xaeroworldmap-common.txt";
            text = ''
              allowCaveModeOnServer:true
              allowNetherCaveModeOnServer:true
              registerStatusEffects:false
              everyoneTracksEveryone:false
            '';
          };
          "config/configurabledespawntimer/specific_despawn_times.txt" = ./specific_despawn_times.txt;
        };

        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              amber = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/vjGZJDu5/versions/UOQGwZI8/amber-fabric-1.21.4-2.1.0%2B1.21.4.jar";
                sha512 = "58d4d73038ea6145ca9f40f9e6ca231e151c9f7ffefbd90fb5d3cb6c0dc6796d96d5f6b83447e90efbd870e4527f646a99cb896490b75b037c2d428ffe6e812e";
              };
              appleskin = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/cHQjeYVS/appleskin-fabric-mc1.21.3-3.0.6.jar";
                sha512 = "b572a3eea43e0084819c88dd7fac6a0a5d5555d9b73df927b97f29764f281cadbfc8cc5f8f6b6920f1677bcec87b411e5a582d305a191735ad8d60fc90900900";
              };
              architectury-api = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/XRwibvvn/architectury-15.0.1-fabric.jar";
                sha512 = "df0e163a560439c1911c584821a643c665b13bbd541db9a9f318cdf33db0aee4573e3c901e4a3aad585e10013de1b4dc62143dce0855a2c915fcd0b35ee28263";
              };
              badoptimizations = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/g96Z4WVZ/versions/EPTfY6pQ/BadOptimizations-2.2.1-1.21.2-21.4.jar";
                sha512 = "c5ec3cf6bc621e867223584454f47fb8c6cbcefc961ba0ef7b7eb848dc287d0682b92677e1b965e2d1b481c451bfc9ebd7d0d3a8a644d05b7a9e1e417462fb64";
              };
              balm = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/MBAkmtvl/versions/6yIBlv3N/balm-fabric-1.21.4-21.4.6.jar";
                sha512 = "3854e338ff9aeba5d9fb1b38b8a49f77d1cf022167709b8d3bea6d6e9eb3717e009345c6d1a12a51dc31fe5c8fb213090283a8700d0e651b06ffc2853532c42d";
              };
              better-fabric-console = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/Y8o1j1Sf/versions/3d1g5aTY/better-fabric-console-mc1.21.4-1.2.2.jar";
                sha512 = "aa7ea5e6fad06927462655331985e58d270bf2f6ac31a9c685830e8d4249c6a3de51f2a2e63ddef150432040448926c3238d3bab4722a26733c5e7db64359563";
              };
              clumps = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/1ZHtT6Xo/Clumps-fabric-1.21.4-22.0.0.1.jar";
                sha512 = "86909659af2f4b481ae9b230996e86658e622424e28b808d069144bf116bf47191df74cfec8b88bbc37ec9ad8cf5a4a24a0f21b39d6c456132331881c8575aeb";
              };
              collective = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/F3ciVO4i/collective-1.21.4-7.89.jar";
                sha512 = "8659df746343e697388b878b52d8eb49027ca528a75f7549177539bf21af26c4f0053acf4552abb36c8d5e5010d6d07976ba64e2b256cda4145785a6acab795d";
              };
              configurable-despawn-timer = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/9olMJ5Qp/versions/dOdzt501/configurabledespawntimer-1.21.4-4.2.jar";
                sha512 = "6b03a9d6aa6ea0b81f52ad01ce7646f1a44e893f1f12e06d7947a029d44fb58b52a6102267ab05bac847cab8aeea8fc4b888fde1636219e760f5c9829d772de9";
              };
              debugify = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/QwxR6Gcd/versions/yjpSgPEw/Debugify-1.21.4%2B1.1.jar";
                sha512 = "6fcc75db9606e443b976b913aee9cba244dc288f652c1d992329087eefae174f92b345966c925e3749d7b819634f0db4e5a285200597b9641788f22a7c7e2ea5";
              };
              fabric-api = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/r5NCKSxv/fabric-api-0.114.3%2B1.21.4.jar";
                sha512 = "37eae71ab45a27bf3855d650b3abcec093daf9271ed7a9ffe5af1729b83605a7146beb2cccf0b15f1337cb444557499c528429f8109b42e4fce61ba9c6e4c392";
              };
              ferrite-core = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/uXXizFIs/versions/IPM0JlHd/ferritecore-7.1.1-fabric.jar";
                sha512 = "f41dc9e8b28327a1e29b14667cb42ae5e7e17bcfa4495260f6f851a80d4b08d98a30d5c52b110007ee325f02dac7431e3fad4560c6840af0bf347afad48c5aac";
              };
              forge-config-api-port = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/ohNO6lps/versions/lTrPTmMK/ForgeConfigAPIPort-v21.4.1-1.21.4-Fabric.jar";
                sha512 = "a5f84411c0b7b9e5e8d267e268183fcb2e46df955fd976ed3f4bc1fd45249ab5f902a23ab93cbdc45d5bb409a5d570e7f7ec9794ca74f4b6115bf3e95d29914b";
              };
              immediatelyfast = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/5ZwdcRci/versions/gh2TGVZk/ImmediatelyFast-Fabric-1.3.3%2B1.21.4.jar";
                sha512 = "29e2ba985c476a190da2686ef567632390ab256efb3b99f0b10caf02d58907796c6cfa97f22ea71aef09a4c73a241ce23a750742dca2f460b2d44db85d7b5045";
              };
              inventory-essentials = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/Boon8xwi/versions/hDg8NyPb/inventoryessentials-fabric-1.21.4-21.4.1.jar";
                sha512 = "608edf8877c054248e7d3990704241beff2fedc9066e52f0c015a303f13d7408d63798ac86e64ec2e3551e2f0213ffa6b49e3071c18fbb7a6f09334d525d8f11";
              };
              jamlib = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/IYY9Siz8/versions/2J8TKset/jamlib-fabric-1.2.2%2B1.21.4.jar";
                sha512 = "b20e4d625d36d16b06eaa8410bf01042487d2b5896a1f0cffc6b713b3e1112498ef63a021ee776da02d79d367c658935aaba20273d7f2f4a731d2b1890e484e2";
              };
              krypton = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
                sha512 = "5f8cf96c79bfd4d893f1d70da582e62026bed36af49a7fa7b1e00fb6efb28d9ad6a1eec147020496b4fe38693d33fe6bfcd1eebbd93475612ee44290c2483784";
              };
              liteminer = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/VTnHoofC/versions/OfUBGho0/liteminer-fabric-1.21.4-1.0.0%2B1.21.4.jar";
                sha512 = "d8cae40d5934469d37ee0bbf5626d919dd9174f1e5c71d6291a3b8b93439a7405cb986e8208f3bc8a343b7f596124ec01a5c98cf0e0d77f94683beef3e871ae6";
              };
              lithium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/6SB2ZRPm/lithium-fabric-0.14.5%2Bmc1.21.4.jar";
                sha512 = "4e523a6c5148a29aed9900476b1f05647c7f22e9912212b3e235c1c69ba1df12a21b64f1dabc91571c2ce2aecdb3b98dda27834e8e3f753f000fce77acab28fd";
              };
              modernfix = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/nmDcB62a/versions/gx7PIV8n/modernfix-fabric-5.20.1%2Bmc1.21.4.jar";
                sha512 = "e1596a89dc100f454c445d64b5ebf59f1788de22270a4ca52837337abe6a76c517c771e234ededbadf5b51dbb62efe1bc0eccee841c45bc263f9406d8348dfe8";
              };
              no-chat-reports = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/9xt05630/NoChatReports-FABRIC-1.21.4-v2.11.0.jar";
                sha512 = "d343b05c8e50f1de15791ff622ad44eeca6cdcb21e960a267a17d71506c61ca79b1c824167779e44d778ca18dcbdebe594ff234fbe355b68d25cdb5b6afd6e4f";
              };
              noisium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/9NHdQfkN/noisium-fabric-2.5.0%2Bmc1.21.4.jar";
                sha512 = "3119f9325a9ce13d851d4f6eddabade382222c80296266506a155f8e12f32a195a00a75c40a8d062e4439f5a7ef66f3af9a46f9f3b3cb799f3b66b73ca2edee8";
              };
              rightclickharvest = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/Cnejf5xM/versions/lylk05D8/rightclickharvest-fabric-4.4.4%2B1.21.4.jar";
                sha512 = "c972c4539652adb01f2d7d7e313be39dd49f44a71510a0fce64ae1915b44968b2450ace3e5c38af8959e76792f813ca56ee7fbc4f012e7b6f27d10934828e7f3";
              };
              sodium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/AANobbMI/versions/tu8qILqH/sodium-fabric-0.6.6%2Bmc1.21.4.jar";
                sha512 = "977606f8f344423a1986efded96e9844d1e0efaf11d877f8bec74c4b8711f9d909ddeaf8ba3126b26f704f0c6362f44c661e435cdbed48272bd03b82557314b6";
              };
              spark = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/l6YH9Als/versions/X2sypdTL/spark-1.10.121-fabric.jar";
                sha512 = "f164ca7dad6baf5e33b3a1b355319ddad264f2b27d2592fd80581d9dcaf35978149d005a159f1e0a116162a31dad4dc553cbaf3af70cc10285f63ca367fe4de5";
              };
              where-is-it = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/FCTyEqkn/versions/K6qcgGyq/whereisit-2.6.4%2B1.21.2.jar";
                sha512 = "56babbe7d36fb5b32e6b961fcfb76d0abf7f3918a75c07797823df75bb284bc79654284e4cda09d1146d9dc69b6e531c26682d69413779be0f040201185d2022";
              };
              xaeros-minimap = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1bokaNcj/versions/pGS4L9Gk/Xaeros_Minimap_24.7.1_Fabric_1.21.4.jar";
                sha512 = "45862a73c95fc0cd37115274129ab0bb2267d5a22bd4d6a63f8f61d474f075ea58f5bd4e9b80fc6bc030bf155805557219508fd43f5c258b94ce93fe7dec6a68";
              };
              xaeros-world-map = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/NcUtCpym/versions/BnFw7PFl/XaerosWorldMap_1.39.2_Fabric_1.21.4.jar";
                sha512 = "36c7b9036aa3a2899e4758cc935370ba1e7bf41f8ae0eb25d301ae2f18591bb0e4abfa748c968abd3edd471857ae7dc211217ea07d50ecbd8300df25678008a5";
              };
              yacl = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1eAoo2KR/versions/VtWuZoXP/YetAnotherConfigLib-3.6.2%2B1.21.4-fabric.jar";
                sha512 = "50f3996aa4382692bbe569ee26506dacd0f4775d86964b5a5c47451e9514d5bf755b5fc1b75e629fc6391fe33d98598977e15c8880ed0f5785c5511ac3360933";
              };
            }
          );
        };
      };
    };
  };
}
