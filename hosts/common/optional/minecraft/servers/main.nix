{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  enable = true;
  package = pkgs.fabricServers.fabric-1_21_4;
  autoStart = true;
  restart = "always";
  serverProperties = {
    server-port = config.hostSpec.networking.ports.minecraft;
    white-list = true;
    difficulty = "normal";
    view-distance = 16;
  };
  whitelist = builtins.listToAttrs (
    builtins.map (player: {
      inherit (player) name;
      value = player.uuid;
    }) inputs.nix-secrets.minecraft.players
  );
  jvmOpts = "-Xmx4G";
  files = {
    "ops.json".value =
      lib.map
        (player: {
          inherit (player) name uuid;
          level = player.opLevel;
          bypassesPlayerLimit = false;
        })
        (
          builtins.filter (
            player: player.opLevel > 0 && player.opLevel <= 4
          ) inputs.nix-secrets.minecraft.players
        );

    "config/configurabledespawntimer/specific_despawn_times.txt" = ./specific_despawn_times.txt;
    "config/inventoryessentials-common.toml".value = {
      allowBulkTransferAllOnEmptySlot = true;
      forceClientImplementation = false;
    };
    "config/discord-mc-chat.json".value = {
      generic = {
        adminsIds = [ inputs.nix-secrets.discordUserID ];
        allowedMentions = [
          "users"
          null
        ];
        announceAdvancements = true;
        announceDeathMessages = true;
        announceHighMspt = true;
        announcePlayerJoinLeave = true;
        announceServerStartStop = false;
        avatarApi = "https://mc-heads.net/avatar/{player_uuid}.png";
        botListeningActivity = "";
        botPlayingActivity = "Minecraft (%onlinePlayerCount%/%maxPlayerCount%)";
        botToken = "@bottoken@";
        broadcastChatMessages = true;
        broadcastPlayerCommandExecution = false;
        broadcastSlashCommandExecution = false;
        channelId = inputs.nix-secrets.minecraft.channelID;
        channelTopicUpdateInterval = 600000;
        consoleLogChannelId = "";
        discordNewlineLimit = 3;
        formatChatMessages = true;
        language = "en_us";
        mentionAdminsForUpdates = false;
        msptCheckInterval = 5000;
        msptLimit = 50;
        notifyUpdates = false;
        showServerStatusInBotStatus = true;
        shutdownImmediately = false;
        updateChannelTopic = true;
        updateNotificationChannelId = "";
        useServerNickname = true;
        useUuidInsteadOfName = true;
        useWebhook = true;
        whitelistRequiresAdmin = true;
      };
    };
    "world/carpet.conf" = pkgs.writeTextFile {
      name = "carpet.conf";
      text = ''
        locked

        fastRedstoneDust true
        shulkerSpawningInEndCities false
        commandPlayer true
        commandScript false
        xpNoCooldown true
        missingTools true
        defaultLoggers mobcaps,tps
        ctrlQCraftingFix true
        optimizedTNT true
        cleanLogs true
        accurateBlockPlacement true
      '';
    };
    "config/EssentialCommands.properties" = pkgs.writeTextFile {
      name = "EssentialCommands.properties";
      text = ''
        afk_prefix={"text"\:"[AFK] ","color"\:"gray"}
        allow_back_on_death=false
        allow_teleport_between_dimensions=true
        auto_afk_enabled=true
        auto_afk_time=PT15M
        broadcast_to_ops=false
        check_for_updates=false
        formatting_accent={"color"\:"light_purple"}
        formatting_default={"color"\:"gold"}
        formatting_error={"color"\:"red"}
        invuln_while_afk=false
        language=en_us
        motd=
        print_teleport_coordinates=false
        register_top_level_commands=true
        respawn_at_ec_spawn=Never
        teleport_cooldown=1.0
        teleport_delay=0.0
        teleport_interrupt_on_damaged=true
        teleport_interrupt_on_move=false
        teleport_interrupt_on_move_max_blocks=3.0
        teleport_request_duration=60
        use_permissions_api=true
      '';
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
    "config/voicechat/voicechat-server.properties" = pkgs.writeText "voicechat-server.properties" ''
      # Setting this to "-1" sets the port to the Minecraft servers port (Not recommended)
      port=${builtins.toString (config.hostSpec.networking.ports.minecraft + 1)}
      # Leave empty to use 'server-ip' of server.properties
      bind_address=
      # The distance to where the voice can be heard
      max_voice_distance=48.0
      # The multiplier of the voice distance when crouching
      crouch_distance_multiplier=1.0
      # The multiplier of the voice distance when whispering
      whisper_distance_multiplier=0.5
      # The opus codec
      # Possible values are 'VOIP', 'AUDIO' and 'RESTRICTED_LOWDELAY'
      codec=VOIP
      # The maximum size in bytes that voice packets are allowed to have
      mtu_size=1024
      # The frequency at which keep alive packets are sent
      # Setting this to a higher value may result in timeouts
      keep_alive=1000
      # If group chats are allowed
      enable_groups=true
      # The host name that clients should use to connect to the voice chat
      # This may also include a port, e.g. 'example.com:24454'
      # Don't change this value if you don't know what you are doing
      voice_host=
      # If players are allowed to record the voice chat
      allow_recording=true
      # If spectators are allowed to talk to other players
      spectator_interaction=false
      # If spectators can talk to players they are spectating
      spectator_player_possession=false
      # If players without the mod should get kicked from the server
      force_voice_chat=false
      # The amount of milliseconds, the server should wait to check if the player has the mod installed
      # Only active when force_voice_chat is set to true
      login_timeout=10000
      # The range where the voice chat should broadcast audio to
      # A value <0 means 'max_voice_distance'
      broadcast_range=-1.0
      # If the voice chat server should reply to pings
      allow_pings=true
    '';
  };

  symlinks = {

    # GitHub
    "mods/carpet.jar" = pkgs.fetchurl {
      url = "https://github.com/gnembon/fabric-carpet/releases/download/1.4.161/fabric-carpet-1.21.4-1.4.161+v241203.jar";
      sha512 = "fd42f43ae89af7553ee1b8240efda178a05f5b0f45fe359651cea468cfd11fe24996e991c338522f4a17b07b917e9ebda4a5cfa8551fca280c81e536b240a96c";
    };
    "mods/carpet-extra.jar" = pkgs.fetchurl {
      url = "https://github.com/gnembon/carpet-extra/releases/download/1.4.161/carpet-extra-1.21.4-1.4.161.jar";
      sha512 = "8afefbc2827151209141b3cbb7d7f3b3ed84befe497446ba384dc0d5cd4e63149aac91c10eb3f6bcc1e942b94df504703fd5cba7814419ead3d0154b229d3203";
    };

    # Modrinth

    "mods/amber.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/vjGZJDu5/versions/UOQGwZI8/amber-fabric-1.21.4-2.1.0%2B1.21.4.jar";
      sha512 = "58d4d73038ea6145ca9f40f9e6ca231e151c9f7ffefbd90fb5d3cb6c0dc6796d96d5f6b83447e90efbd870e4527f646a99cb896490b75b037c2d428ffe6e812e";
    };
    "mods/appleskin.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/cHQjeYVS/appleskin-fabric-mc1.21.3-3.0.6.jar";
      sha512 = "b572a3eea43e0084819c88dd7fac6a0a5d5555d9b73df927b97f29764f281cadbfc8cc5f8f6b6920f1677bcec87b411e5a582d305a191735ad8d60fc90900900";
    };
    "mods/architectury-api.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/XRwibvvn/architectury-15.0.1-fabric.jar";
      sha512 = "df0e163a560439c1911c584821a643c665b13bbd541db9a9f318cdf33db0aee4573e3c901e4a3aad585e10013de1b4dc62143dce0855a2c915fcd0b35ee28263";
    };
    "mods/badoptimizations.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/g96Z4WVZ/versions/EPTfY6pQ/BadOptimizations-2.2.1-1.21.2-21.4.jar";
      sha512 = "c5ec3cf6bc621e867223584454f47fb8c6cbcefc961ba0ef7b7eb848dc287d0682b92677e1b965e2d1b481c451bfc9ebd7d0d3a8a644d05b7a9e1e417462fb64";
    };
    "mods/balm.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/MBAkmtvl/versions/6yIBlv3N/balm-fabric-1.21.4-21.4.6.jar";
      sha512 = "3854e338ff9aeba5d9fb1b38b8a49f77d1cf022167709b8d3bea6d6e9eb3717e009345c6d1a12a51dc31fe5c8fb213090283a8700d0e651b06ffc2853532c42d";
    };
    "mods/better-fabric-console.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Y8o1j1Sf/versions/3d1g5aTY/better-fabric-console-mc1.21.4-1.2.2.jar";
      sha512 = "aa7ea5e6fad06927462655331985e58d270bf2f6ac31a9c685830e8d4249c6a3de51f2a2e63ddef150432040448926c3238d3bab4722a26733c5e7db64359563";
    };
    "mods/cloth-config.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/9s6osm5g/versions/TJ6o2sr4/cloth-config-17.0.144-fabric.jar";
      sha512 = "ecc59da51149250284b0752475c7b328e0b0325888948391597afc638d6e67fa436297af12d2067376de0098ffa6ca86aa3b8d6011356c179222404c701c6345";
    };
    "mods/collective.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/F3ciVO4i/collective-1.21.4-7.89.jar";
      sha512 = "8659df746343e697388b878b52d8eb49027ca528a75f7549177539bf21af26c4f0053acf4552abb36c8d5e5010d6d07976ba64e2b256cda4145785a6acab795d";
    };
    "mods/configurable-despawn-timer.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/9olMJ5Qp/versions/dOdzt501/configurabledespawntimer-1.21.4-4.2.jar";
      sha512 = "6b03a9d6aa6ea0b81f52ad01ce7646f1a44e893f1f12e06d7947a029d44fb58b52a6102267ab05bac847cab8aeea8fc4b888fde1636219e760f5c9829d772de9";
    };
    "mods/debugify.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/QwxR6Gcd/versions/yjpSgPEw/Debugify-1.21.4%2B1.1.jar";
      sha512 = "6fcc75db9606e443b976b913aee9cba244dc288f652c1d992329087eefae174f92b345966c925e3749d7b819634f0db4e5a285200597b9641788f22a7c7e2ea5";
    };
    "mods/discord-mc-chat.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/D0sHdnXY/versions/fgxnpAd1/Discord-MC-Chat-2.4.0.jar";
      sha512 = "09f88bf9ab1347a5eb90ed7a55a7c30846d3451557c9a9c366d3d68deed4655e5e4e124f2cc9404df5d3841a28dc73890191e9ea97e5655d0f1d1321f83a3128";
    };
    "mods/essential-commands.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/6VdDUivB/versions/dWRItO8P/essential_commands-0.36.0-mc1.21.3.jar";
      sha512 = "2b5bde97113f319d1d55b37832e0faf54eb7a903148fb01414dbec1adaeffa8f6b6451a37276b0102af83100736349821790e62ed1672b0f58e3a04c7d85108c";
    };
    "mods/fabric-api.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/r5NCKSxv/fabric-api-0.114.3%2B1.21.4.jar";
      sha512 = "37eae71ab45a27bf3855d650b3abcec093daf9271ed7a9ffe5af1729b83605a7146beb2cccf0b15f1337cb444557499c528429f8109b42e4fce61ba9c6e4c392";
    };
    "mods/ferrite-core.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/IPM0JlHd/ferritecore-7.1.1-fabric.jar";
      sha512 = "f41dc9e8b28327a1e29b14667cb42ae5e7e17bcfa4495260f6f851a80d4b08d98a30d5c52b110007ee325f02dac7431e3fad4560c6840af0bf347afad48c5aac";
    };
    "mods/forge-config-api-port.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/ohNO6lps/versions/lTrPTmMK/ForgeConfigAPIPort-v21.4.1-1.21.4-Fabric.jar";
      sha512 = "a5f84411c0b7b9e5e8d267e268183fcb2e46df955fd976ed3f4bc1fd45249ab5f902a23ab93cbdc45d5bb409a5d570e7f7ec9794ca74f4b6115bf3e95d29914b";
    };
    "mods/immediatelyfast.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/5ZwdcRci/versions/gh2TGVZk/ImmediatelyFast-Fabric-1.3.3%2B1.21.4.jar";
      sha512 = "29e2ba985c476a190da2686ef567632390ab256efb3b99f0b10caf02d58907796c6cfa97f22ea71aef09a4c73a241ce23a750742dca2f460b2d44db85d7b5045";
    };
    "mods/inventory-essentials.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Boon8xwi/versions/hDg8NyPb/inventoryessentials-fabric-1.21.4-21.4.1.jar";
      sha512 = "608edf8877c054248e7d3990704241beff2fedc9066e52f0c015a303f13d7408d63798ac86e64ec2e3551e2f0213ffa6b49e3071c18fbb7a6f09334d525d8f11";
    };
    "mods/jade.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/S1GWTEhB/Jade-1.21.4-Fabric-17.2.0.jar";
      sha512 = "ad7c711abcd9d6d0063acec4d03ee52b7f3a3e0d69f1da4b2275cb8f3860c6d4f6cafaa98e387ffd7a1f7c1716621c8e6647cada55f3c02a143db5d854eee08a";
    };
    "mods/jamlib.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/IYY9Siz8/versions/2J8TKset/jamlib-fabric-1.2.2%2B1.21.4.jar";
      sha512 = "b20e4d625d36d16b06eaa8410bf01042487d2b5896a1f0cffc6b713b3e1112498ef63a021ee776da02d79d367c658935aaba20273d7f2f4a731d2b1890e484e2";
    };
    "mods/krypton.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
      sha512 = "5f8cf96c79bfd4d893f1d70da582e62026bed36af49a7fa7b1e00fb6efb28d9ad6a1eec147020496b4fe38693d33fe6bfcd1eebbd93475612ee44290c2483784";
    };
    "mods/liteminer.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/VTnHoofC/versions/OfUBGho0/liteminer-fabric-1.21.4-1.0.0%2B1.21.4.jar";
      sha512 = "d8cae40d5934469d37ee0bbf5626d919dd9174f1e5c71d6291a3b8b93439a7405cb986e8208f3bc8a343b7f596124ec01a5c98cf0e0d77f94683beef3e871ae6";
    };
    "mods/lithium.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/6SB2ZRPm/lithium-fabric-0.14.5%2Bmc1.21.4.jar";
      sha512 = "4e523a6c5148a29aed9900476b1f05647c7f22e9912212b3e235c1c69ba1df12a21b64f1dabc91571c2ce2aecdb3b98dda27834e8e3f753f000fce77acab28fd";
    };
    "mods/luckperms.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Vebnzrzj/versions/6h9SnsZu/LuckPerms-Fabric-5.4.150.jar";
      sha512 = "d616346f5ae1cce2137ce589323e89263a08b4bd26e547fa67d2b87a729740d70dfd2b6b06ffd6b72433f7e20c03bde3b4da69c7cd325f295d1f28f1861c8698";
    };
    "mods/modernfix.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/nmDcB62a/versions/gx7PIV8n/modernfix-fabric-5.20.1%2Bmc1.21.4.jar";
      sha512 = "e1596a89dc100f454c445d64b5ebf59f1788de22270a4ca52837337abe6a76c517c771e234ededbadf5b51dbb62efe1bc0eccee841c45bc263f9406d8348dfe8";
    };
    "mods/no-chat-reports.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/9xt05630/NoChatReports-FABRIC-1.21.4-v2.11.0.jar";
      sha512 = "d343b05c8e50f1de15791ff622ad44eeca6cdcb21e960a267a17d71506c61ca79b1c824167779e44d778ca18dcbdebe594ff234fbe355b68d25cdb5b6afd6e4f";
    };
    "mods/noisium.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/9NHdQfkN/noisium-fabric-2.5.0%2Bmc1.21.4.jar";
      sha512 = "3119f9325a9ce13d851d4f6eddabade382222c80296266506a155f8e12f32a195a00a75c40a8d062e4439f5a7ef66f3af9a46f9f3b3cb799f3b66b73ca2edee8";
    };
    "mods/rightclickharvest.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Cnejf5xM/versions/lylk05D8/rightclickharvest-fabric-4.4.4%2B1.21.4.jar";
      sha512 = "c972c4539652adb01f2d7d7e313be39dd49f44a71510a0fce64ae1915b44968b2450ace3e5c38af8959e76792f813ca56ee7fbc4f012e7b6f27d10934828e7f3";
    };
    "mods/servux.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/fKoMLUos/servux-fabric-1.21.4-0.5.1.jar";
      sha512 = "49510a9e8d6894567f5d3461fb4b6e87e4d8ecb0664f337fe38f3a79b47887dbe1ac6a233aa0cc4e115b67c4d15ca895fd88a4ee941cdc6f86237a2bbd0c36f1";
    };
    "mods/shulkerboxtooltip.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/2M01OLQq/versions/fy4w1xut/shulkerboxtooltip-fabric-5.2.3%2B1.21.4.jar";
      sha512 = "002f62515affb0599c8ea0b144fe79d97a7e8795f204dad9f9a8ce38fe14fd3146164b2256de1c52a5639434db4c002000642e077b55ae7fe4daf477e1c7ba08";
    };
    "mods/simple-voice-chat.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/4Zzq92HE/voicechat-fabric-1.21.4-2.5.27.jar";
      sha512 = "9ef2ab20cc075a1e43ea7160ac99d5d89a3cc908aee11f443a59e525f8ab3ee3376d768b09b1c8428acb709420d27e1af8e5c385c2309c1bbf5886011e568555";
    };
    "mods/sodium.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/AANobbMI/versions/tu8qILqH/sodium-fabric-0.6.6%2Bmc1.21.4.jar";
      sha512 = "977606f8f344423a1986efded96e9844d1e0efaf11d877f8bec74c4b8711f9d909ddeaf8ba3126b26f704f0c6362f44c661e435cdbed48272bd03b82557314b6";
    };
    "mods/spark.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/l6YH9Als/versions/X2sypdTL/spark-1.10.121-fabric.jar";
      sha512 = "f164ca7dad6baf5e33b3a1b355319ddad264f2b27d2592fd80581d9dcaf35978149d005a159f1e0a116162a31dad4dc553cbaf3af70cc10285f63ca367fe4de5";
    };
    "mods/vanilla-permissions.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/fdZkP5Bb/versions/7awQNHzw/vanilla-permissions-0.2.4%2B1.21.3.jar";
      sha512 = "6f182c3f976fb3a5e9a542094bc0fcf7a120aa55a32e5b0ed7c162034a24287ea1dbb5e5138c4af41c284900b4a05daca6b998c2d8c973e33188879832dcff55";
    };
    "mods/where-is-it.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/FCTyEqkn/versions/K6qcgGyq/whereisit-2.6.4%2B1.21.2.jar";
      sha512 = "56babbe7d36fb5b32e6b961fcfb76d0abf7f3918a75c07797823df75bb284bc79654284e4cda09d1146d9dc69b6e531c26682d69413779be0f040201185d2022";
    };
    "mods/xaeros-minimap.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/1bokaNcj/versions/pGS4L9Gk/Xaeros_Minimap_24.7.1_Fabric_1.21.4.jar";
      sha512 = "45862a73c95fc0cd37115274129ab0bb2267d5a22bd4d6a63f8f61d474f075ea58f5bd4e9b80fc6bc030bf155805557219508fd43f5c258b94ce93fe7dec6a68";
    };
    "mods/xaeros-world-map.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/NcUtCpym/versions/BnFw7PFl/XaerosWorldMap_1.39.2_Fabric_1.21.4.jar";
      sha512 = "36c7b9036aa3a2899e4758cc935370ba1e7bf41f8ae0eb25d301ae2f18591bb0e4abfa748c968abd3edd471857ae7dc211217ea07d50ecbd8300df25678008a5";
    };
    "mods/yacl.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/1eAoo2KR/versions/VtWuZoXP/YetAnotherConfigLib-3.6.2%2B1.21.4-fabric.jar";
      sha512 = "50f3996aa4382692bbe569ee26506dacd0f4775d86964b5a5c47451e9514d5bf755b5fc1b75e629fc6391fe33d98598977e15c8880ed0f5785c5511ac3360933";
    };
  };
}
