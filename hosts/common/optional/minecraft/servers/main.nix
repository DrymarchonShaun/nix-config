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
  # managementSystem = {
  #   tmux.enable = false;
  #   systemd-socket.enable = true;
  # };
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

      bulkTransferArmorSets = true;

      enableBulkDrop = true;

      enableBulkTransfer = true;

      enableBulkTransferAll = true;

      enableBulkTransferSingle = true;

      enableShiftDrag = true;

      enableSingleTransfer = true;

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
    "mods/amber.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/vjGZJDu5/versions/xLlRAY41/amber-fabric-1.21.4-3.0.0%2B1.21.4.jar";
      sha512 = "f99255dcf8c3f94b059557c494eb3fb0af91506adc5f52bd3fe6f70a928a6be3cffbccdd483b731715d67fefcb844bb5336321ca2d1426858bb5c553ec61408e";
    };
    "mods/appleskin.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/cHQjeYVS/appleskin-fabric-mc1.21.3-3.0.6.jar";
      sha512 = "b572a3eea43e0084819c88dd7fac6a0a5d5555d9b73df927b97f29764f281cadbfc8cc5f8f6b6920f1677bcec87b411e5a582d305a191735ad8d60fc90900900";
    };
    "mods/architectury-api.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/73nlw3WM/architectury-15.0.3-fabric.jar";
      sha512 = "6acc7cfccfc6e93fd8c1895fb2c489cbabd27265f38f7cbad98ddaab2cb2e6d1601633bd12cf26fc0bb100a87949ee06b872f333cf7b8490cccc0082ac586dcb";
    };
    "mods/badoptimizations.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/g96Z4WVZ/versions/PGSmdolb/BadOptimizations-2.3.0-1.21.2-21.5.jar";
      sha512 = "f1079c91f27dadd54ec36d42eae55c4fb95675aac8ebaaf40cecd8221d4819f3f28ba24b7ce5d31b2fca62a8489fe12860ad0bf187d9df44a928d78e60a9cb53";
    };
    "mods/balm.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/MBAkmtvl/versions/RMBKhF0u/balm-fabric-1.21.4-21.4.36.jar";
      sha512 = "d4a91effe7475fcf08cc62794fc75e665c361c0987b89806e8b8804f7b1f627d79904fa9a040e8cc3f1abb0b5af459a85186feaecc0fd002d36f585c89740be5";
    };
    "mods/better-fabric-console.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Y8o1j1Sf/versions/3d1g5aTY/better-fabric-console-mc1.21.4-1.2.2.jar";
      sha512 = "aa7ea5e6fad06927462655331985e58d270bf2f6ac31a9c685830e8d4249c6a3de51f2a2e63ddef150432040448926c3238d3bab4722a26733c5e7db64359563";
    };
    "mods/carpet-extra.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/VX3TgwQh/versions/jLwlJK0f/carpet-extra-1.21.4-1.4.161.jar";
      sha512 = "8afefbc2827151209141b3cbb7d7f3b3ed84befe497446ba384dc0d5cd4e63149aac91c10eb3f6bcc1e942b94df504703fd5cba7814419ead3d0154b229d3203";
    };
    "mods/carpet.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/TQTTVgYE/versions/aVB2lYQQ/fabric-carpet-1.21.4-1.4.161%2Bv241203.jar";
      sha512 = "fd42f43ae89af7553ee1b8240efda178a05f5b0f45fe359651cea468cfd11fe24996e991c338522f4a17b07b917e9ebda4a5cfa8551fca280c81e536b240a96c";
    };
    "mods/cloth-config.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/9s6osm5g/versions/TJ6o2sr4/cloth-config-17.0.144-fabric.jar";
      sha512 = "ecc59da51149250284b0752475c7b328e0b0325888948391597afc638d6e67fa436297af12d2067376de0098ffa6ca86aa3b8d6011356c179222404c701c6345";
    };
    "mods/collective.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/I5jY2gQ2/collective-1.21.4-8.3.jar";
      sha512 = "95c18b55a631bfdcbc501c17238f36c1f284d90a866f498dbf2b77ce7b9dcb0260cba0143a16dcbf254660710ea8fdbd8948cac94139e660bf25581b49fa2337";
    };
    "mods/configurable-despawn-timer.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/9olMJ5Qp/versions/8yBlnZRg/configurabledespawntimer-1.21.4-4.3.jar";
      sha512 = "7ccb9e7a35cfdef822a7029e2f940d3f1e76fc24499fc11effd83a99eeb3c593febe40fd918a5486a67a89c75a61052acb419701be34b635d8cff4f9805d230a";
    };
    "mods/debugify.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/QwxR6Gcd/versions/yjpSgPEw/Debugify-1.21.4%2B1.1.jar";
      sha512 = "6fcc75db9606e443b976b913aee9cba244dc288f652c1d992329087eefae174f92b345966c925e3749d7b819634f0db4e5a285200597b9641788f22a7c7e2ea5";
    };
    "mods/discord-mc-chat.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/D0sHdnXY/versions/PtVawIb0/Discord-MC-Chat-2.5.0.jar";
      sha512 = "5d653d21048cea1eeaff13bf1f63619133384385b4da21c5105c64e4b1b6ac67c04fd8534768d0a5125a9c940a4dc38ce64cba6b202e86e705a5ef9b45a8c4d5";
    };
    "mods/essential-commands.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/6VdDUivB/versions/gDvOqDt9/essential_commands-0.37.0-mc1.21.4.jar";
      sha512 = "be89b0b21f57e27b3d9844f99296b1ad18526672a56e338a266dd654bfdf39d9ec41e2f8a505f5561a71fc72cf105a8ed96ad46a4d94f161a875046a47d8b8a6";
    };
    "mods/fabric-api.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/sVqpGIb1/fabric-api-0.119.3%2B1.21.4.jar";
      sha512 = "a1927d45902c766b8d21f93cddc36991045eeb1adca5dfeea1c3b6378ce6aa66ae99cf2322ca6e337c58352c4d55fd5226655bc8886080fa864c27f83b18c1d9";
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
      url = "https://cdn.modrinth.com/data/5ZwdcRci/versions/TBPG2PYa/ImmediatelyFast-Fabric-1.8.1%2B1.21.4.jar";
      sha512 = "b3379168a1576ee80abf3ae7c6234dbc541df0616ec6d95e7a9d9af44619100bacd11a85366e17cc2157beb15ad6e254191f532cb28fb2e89ad0a47777176211";
    };
    "mods/inventory-essentials.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Boon8xwi/versions/QQtpAYuC/inventoryessentials-fabric-1.21.4-21.4.5.jar";
      sha512 = "f997ce643976591ffe7e34a669162554cbfbcca9033019c933aef99ad2a4d297d252ef27122ab9c2dc4927bfe79ed9204f7362eaa888fec51f458818081f2913";
    };
    "mods/jade.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/sSHUBFoq/Jade-1.21.4-Fabric-17.2.2.jar";
      sha512 = "dbe2ce335170c7a7079595c6341188ef07f54704faab7e3919a7c24130d3b25f321425c5f28107ea706f8d7e47e1d49147882ab05c35cbe6af7ac9d371ca68e7";
    };
    "mods/jamlib.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/IYY9Siz8/versions/GSAIeO3Q/jamlib-fabric-1.3.5%2B1.21.4.jar";
      sha512 = "f212f965dda1283057469ab1952a39a364ed6dd8c06d591cc2464006b692cc4287cd723dc9fefcbd5b2e6e306ec84a121623cde960690df2332ec90c8d6f58fe";
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
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/u8pHPXJl/lithium-fabric-0.15.3%2Bmc1.21.4.jar";
      sha512 = "b8b541c0e968571c8972872b342e34b92573bc9210d455dc1349589f30a67a90d930dbfd99b176ab9b110350ceb53e11118378dc13a35e83a9090826627bdac0";
    };
    "mods/luckperms.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Vebnzrzj/versions/6h9SnsZu/LuckPerms-Fabric-5.4.150.jar";
      sha512 = "d616346f5ae1cce2137ce589323e89263a08b4bd26e547fa67d2b87a729740d70dfd2b6b06ffd6b72433f7e20c03bde3b4da69c7cd325f295d1f28f1861c8698";
    };
    "mods/modernfix.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/nmDcB62a/versions/ZGxQddYr/modernfix-fabric-5.20.3%2Bmc1.21.4.jar";
      sha512 = "ae49114c92a048c9ce79e197fc4df028e186cf13546e710f72247382fa8076f0b70d6aa3224951f4a36c886ca236f099a011f20b021a2b0d1a75c631da4d7d52";
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
      url = "https://cdn.modrinth.com/data/Cnejf5xM/versions/ilSmuwZP/rightclickharvest-fabric-4.5.3%2B1.21.4-patch.1.jar";
      sha512 = "d486b87636fe4960e7c48bd6f2cf266214079a4b3ab4a01fbdc59a02f2179cd0bc25475747de3e7cb7ce38d3e7ccb2369ca87ca1f1634b447e78907e9e528876";
    };
    "mods/servux.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/QtByZXTq/servux-fabric-1.21.4-0.5.4.jar";
      sha512 = "4044acb3c1155c51551f5ef6f2478fe9b1dfa46b8936ac7c3dd26b6d769ee3a5625a3de9dc09da822e0f1ce31f981408e283bbbb788910d3ae8951d728f8e519";
    };
    "mods/shulkerboxtooltip.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/2M01OLQq/versions/zZfEoJB1/shulkerboxtooltip-fabric-5.2.6%2B1.21.4.jar";
      sha512 = "49570eba94cf49829f0680ec45226b48f2394ea0e564d05bf9e336b8ac2c86a5977654bdefb27e7d836112571fa55e0ac9f6d7d2a14c252655ea6e73bed309fe";
    };
    "mods/simple-voice-chat.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/rzxK9Bkj/voicechat-fabric-1.21.4-2.5.35.jar";
      sha512 = "420db59c1df499f758ae39169abedad1bf091d9720b0f9a4c498cca2f3c504a58435336d40d927e8fe57f8451d75b113ee4a358940a757869a4d409f4ab5f039";
    };
    "mods/sodium.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/AANobbMI/versions/c3YkZvne/sodium-fabric-0.6.13%2Bmc1.21.4.jar";
      sha512 = "2c72ca2ddfd27e29ff6c24fccdf6f3d80857bd1014c707017f96cb4a424f94918e53ba21d85f22e3c9171803f8d2c12c99ae857d38d8e85546cc65960b95a2f1";
    };
    "mods/spark.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/l6YH9Als/versions/X2sypdTL/spark-1.10.121-fabric.jar";
      sha512 = "f164ca7dad6baf5e33b3a1b355319ddad264f2b27d2592fd80581d9dcaf35978149d005a159f1e0a116162a31dad4dc553cbaf3af70cc10285f63ca367fe4de5";
    };
    "mods/vanilla-permissions.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/fdZkP5Bb/versions/PYYDl95q/vanilla-permissions-0.2.9%2B1.21.4.jar";
      sha512 = "ef65762de7cc0fd5f4e94268162d0dab65d32da833ea0a0df9683c46c1a26d3cc4e9fa73de0445080d1769ea1c17cf543425a03d54a887b84aed9f8d902913ff";
    };
    "mods/where-is-it.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/FCTyEqkn/versions/K6qcgGyq/whereisit-2.6.4%2B1.21.2.jar";
      sha512 = "56babbe7d36fb5b32e6b961fcfb76d0abf7f3918a75c07797823df75bb284bc79654284e4cda09d1146d9dc69b6e531c26682d69413779be0f040201185d2022";
    };
    "mods/xaeros-minimap.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/1bokaNcj/versions/TFfNbUts/Xaeros_Minimap_25.2.10_Fabric_1.21.4.jar";
      sha512 = "38a7873ca5cf0f2c5e3885f00ab5c814a165e939451ff7d39522adbfb370101a46b189662cea5cb305e992ddf63482399145c5cbd09e175c82ee49d1895a8a19";
    };
    "mods/xaeros-world-map.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/NcUtCpym/versions/xF512qxI/XaerosWorldMap_1.39.12_Fabric_1.21.4.jar";
      sha512 = "e6e0a904f6fb1a8384b17fa980492e465317b55c0fe01eb0ea9f0ffd80a7b224e8dbf4e8626a477ab6b8261e614515142379ee756ff110bc51c61dbb5e68d2b4";
    };
    "mods/yacl.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/1eAoo2KR/versions/axFpNOZX/yet_another_config_lib_v3-3.7.1%2B1.21.4-fabric.jar";
      sha512 = "c816b11402da81e89e50ce77bb7a0dac1b9a8ec686675eec21297da9a0489da3d018bd47a7c52cb80415cff19c291cffeb05ca39836275b00bc189bdb81046d1";
    };
  };
}
